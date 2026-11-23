Proem is an AI harness tailored for developers, that helps keep token consumption low and AI agents accuracy high.

**This harness is also tailored to be extremely generic, so interested developers and companies can fork it to customize to their own needs.**

# Adding or changing a resource

## How to write prompts

Consider that most resources are basically prompts for agents to process and act upon. All following rules contain a few common best practices (all available online for free) to write efficient AI instructions.

0. **WRITE INSTRUCTIONS YOURSELF!** - it may make sense to ask agents to write instructions, as it can tell how an agent sees an instruction as (un)clear. That's a common but honest mistake: agents tend to overthink simple instructions and introduce a lot of *AI slop* when writing any prose text. A good golden rule to follow for this is writing instructions for humans to follow: the easier a human can understand and follow instructions, the easier it will be for an AI to follow them as well.

1. **Drop all obvious instructions** - this is needed at almost all times when we're writing instructions for humans, but for AI agents this means increased context token usage which directly relates to accuracy degradation. There's no thumb rule to decide if a given instruction is obvious or not, so the best approach is to ask to different adapters and models how obvious an instruction is to them.

2. **Do not explain or justify** - agents do **not** need to know why you're asking it to perform a given task, it just needs to know what is to be done and how. As always, remember: any additional information passed to an agent means additional token usage, and that directly relates to accuracy degradation.

3. **Tell agents which commands or scripts to they must run exactly and how** - this is one of the hardest guidelines to follow, as it requires knowing which specific CLI commands an agent needs to run to perform a given task. However, doing this force you to know exactly the sequence of actions an agent needs to take, allowing you to write commands in a way agents can run them and receive only the relevant part of their output. This is what helps the most at keeping token usage as low as possible. If possible, always aim to write `shell/bash` scripts that produce predictable output.

4. **Always have commands and scripts write results to files** - some CLI binaries produce **A LOT** of output, often times containing a lot of unnecessary noise. Allowing agents to run such commands the standard way they do makes them ingest all that output into their context, skyrocketing context size and, therefore, token usage. Having every single agent run those binaries piping their output into files help not poisoning their context and keep it clean, maintaining their efficiency to the best degree possible. This harness also suggests concentrating all output from an orchestrated run into a separate, dedicated folder, so agents can write their own work in an organized way in there and `grep` specific information from other agents' files.

5. **Use files as session context for long-lived jobs** - when you have a job that runs for longer times, it means running an agent a longer time as an orchestrator. If it just keeps listening output from other subagents, its precision can degrade quickly as all those handoffs are read into its context. Following on the item above, a good practice is to have a **manifest** file the orchestrator can create and tell all its subagents to report to, so instead of listening to handoffs it goes directly there and read only what's needed. If needed, subagents can also report in there which files they created and a few description of what can be found in them.

6. **Always give exact commands on how to run subagents** - this follows the recommendation about CLI commands, but with an important remark: although agents know very well how to put other subagents to run, they are not free to decide which pieces of context to give them or not. This is something mandated by adapters, and most times (if not all) vendors will enforce an orchestrator's **full context** to be shoved down a subagent's throat. That can quickly make subagents be spawned with much lower precision than they should actually have. Knowing how to trigger them via command line with all exact parameters and flags to keep not only context to a minimum but also personalizing used models allow testing and tweaking configurations for subagents, letting you reach a "sweet spot" where the subagent's efficiency is good enough while minimizing its cost.

# Planned roadmap

* Define and create the harness used by running agents to use run manifests and write binary outputs to files
* Study and design the ephemeral knowledge base mechanism
    * "Piece of knowledge" discovery
    * Knowledge indexing mechanism