import { $ } from "bun";

export const AgentHubSync = async () => {
  return {
    event: async ({ event }) => {
      // Auto-pull when opencode starts
      if (event.type === "session.created") {
        try {
          await $`cd ~/agent-hub && git pull --quiet 2>/dev/null`;
        } catch {}
      }

      // Auto-push when session goes idle (work is done)
      if (event.type === "session.idle") {
        try {
          await $`cd ~/agent-hub && ./sync.sh 2>/dev/null`;
        } catch {}
      }
    },
  };
};
