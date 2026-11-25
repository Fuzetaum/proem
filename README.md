Proem is an AI harness tailored for developers, that helps keep token consumption low and AI agents accuracy high.

**This harness is also tailored to be extremely generic, so interested developers and companies can fork it to customize to their own needs.**

Full documentation contains **A LOT** of detailed content on how to write good prompts and available mechanisms in this harness. To not pollute this README, refer to [docs README.md](./docs/README.md).

# Planned roadmap

* Define and create the harness used by running agents to use run manifests and write binary outputs to files
    * Define when orchestrators need to be AI agents
    * Define and create additional harness mechanisms to allow replacing unnecessary orchestrating AI agents for runnable scripts
* Define and create the harness to allow defining and customizing models and effort settings for each prompt
    * Fields and formats: prompt frontmatter, run manifest, and repository wide current settings
    * Define and create script to read all settings and convert to adapter-specific model names and settings
        * Define translation mappings for each adapter
        * Create YAML file to contain all mappings allowing easier model translation maintenance
* Study and design the ephemeral knowledge base mechanism
    * "Piece of knowledge" discovery
    * Knowledge indexing mechanism