import { $ } from "bun";
import { homedir } from "os";
import { join } from "path";

const HUB_DIR = join(homedir(), "agent-hub");

export const AgentHubSync = async () => {
  return {
    event: async ({ event }) => {
      // Auto-pull when opencode starts
      if (event.type === "session.created") {
        try {
          await $`git -C ${HUB_DIR} pull --quiet`;
        } catch {}
      }

      // Auto-push when session goes idle (work is done)
      if (event.type === "session.idle") {
        try {
          await $`git -C ${HUB_DIR} add -A`;
          const status = await $`git -C ${HUB_DIR} status --porcelain`;
          if (status.stdout.toString().trim().length > 0) {
            await $`git -C ${HUB_DIR} commit -m "Auto-sync from ${process.env.COMPUTERNAME || process.env.HOSTNAME || "unknown"}"`;
            await $`git -C ${HUB_DIR} push`;
          }
        } catch {}
      }
    },
  };
};
