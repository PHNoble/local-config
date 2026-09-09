// omp extension for wt (git worktree manager).
// Source: ~/.config/omp/wt.ts, symlinked into ~/.omp/agent/extensions/.
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const WT = `${process.env.HOME}/.config/scripts/wt`;

async function runWt(args: string[], cwd: string): Promise<string> {
	const proc = Bun.spawn([WT, ...args], {
		cwd,
		env: { ...process.env, WT_NO_TMUX: "1" },
		stdin: args[0] === "clean" ? new Blob(["y\n"]) : undefined,
		stdout: "pipe",
		stderr: "pipe",
	});
	const [stdout, stderr, code] = await Promise.all([
		new Response(proc.stdout).text(),
		new Response(proc.stderr).text(),
		proc.exited,
	]);
	const out = (stdout + stderr).trim();
	if (code !== 0) throw new Error(out || `wt exited with ${code}`);
	return out || "(ok)";
}

// " <gemstone>" when cwd is inside a wt-managed worktree, else undefined.
function worktreeLabel(cwd: string): string | undefined {
	const root = `${process.env.HOME}/.worktrees/`;
	if (!cwd.startsWith(root)) return undefined;
	const gem = cwd.slice(root.length).split("/")[1];
	return gem ? ` ${gem}` : undefined;
}

export default function (pi: ExtensionAPI) {
	const z = pi.zod;
	pi.setLabel("Worktrees");

	// Status line: show which worktree (gemstone) the session is in.
	const updateStatus = (ctx: { cwd: string; ui: { setStatus(key: string, text?: string): void } }) =>
		ctx.ui.setStatus("worktree", worktreeLabel(ctx.cwd));
	pi.on("session_start", async (_e, ctx) => updateStatus(ctx));
	pi.on("session_switch", async (_e, ctx) => updateStatus(ctx));
	pi.on("turn_start", async (_e, ctx) => updateStatus(ctx));

	pi.registerCommand("wt", {
		description: "git worktrees: /wt ls | new <branch> [base] | rm [-f|-d] <name> | clean [--idle] | path <name>",
		handler: async (args, ctx) => {
			const argv = (args ?? "").trim().split(/\s+/).filter(Boolean);
			if (argv.length === 0) argv.push("ls");
			try {
				ctx.ui.notify(await runWt(argv, ctx.cwd), "info");
			} catch (e) {
				ctx.ui.notify(String(e instanceof Error ? e.message : e), "error");
			}
		},
	});

	pi.registerTool({
		name: "worktree",
		label: "Worktree",
		description:
			"Manage git worktrees for the repo containing cwd. wt-managed worktrees live at ~/.worktrees/{repo}/{gemstone} " +
			"(each gets an unused gemstone name; commands accept gemstone or branch name). " +
			"Actions: ls (list; wt-managed first, then external worktrees made by other tools), " +
			"new (create for branch; optional base), " +
			"rm (remove a worktree, external ones included; default refuses dirty trees and deletes the branch only if merged; " +
			"force discards changes and force-deletes the branch; discard discards changes but keeps the branch), " +
			"clean (remove all merged/gone/detached worktrees), path (print worktree path). " +
			"'new' and 'path' print the worktree path.",
		parameters: z.object({
			action: z.enum(["ls", "new", "rm", "clean", "path"]),
			branch: z.string().optional().describe("branch or gemstone name (new/rm/path)"),
			base: z.string().optional().describe("base branch for new (default: origin HEAD)"),
			force: z.boolean().optional().describe("rm: discard changes and force-delete branch"),
			discard: z.boolean().optional().describe("rm: discard changes but keep the branch"),
		}),
		async execute(_id, params, _signal, _onUpdate, ctx) {
			const argv: string[] = [params.action];
			if (params.action === "rm" && params.force) argv.push("-f");
			if (params.action === "rm" && params.discard) argv.push("-d");
			if (params.branch) argv.push(params.branch);
			if (params.action === "new" && params.base) argv.push(params.base);
			try {
				const out = await runWt(argv, ctx.cwd);
				return { content: [{ type: "text", text: out }] };
			} catch (e) {
				return {
					content: [{ type: "text", text: String(e instanceof Error ? e.message : e) }],
					isError: true,
				};
			}
		},
	});
}
