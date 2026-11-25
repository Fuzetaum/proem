# File organization

Do not navigate into folders *.claude* and *.cursor* - they contain symlinks to some root folders in the repository, and you can end finding diplicated contents through those two folders.

Folders *agents*, *commands* and *rules* contain only their markdown-formatted prompt files, named `<name>.md`. *skills* folder contains folders named after each skill, with an entrypoint `SKILL.md` file in each skill folder.

# Scope nesting

In a markdown file, all information and instructions from a section are inherited by all of its subsections, but are not available to parent sections. **Example**: consider the following file snippet:
```markdown
# Section

Information #1

## Subsection

Information #2

### Subsubsection

Information #3
```

`Information #1` is available to `Section`, `Subsection` and `Subsubsection`. `Information #2` is available to `Subsection` and `Subsubsection`. `Information #3` is only available to `Subsubsection`.

The following sections are exceptions with information available **at all steps** during execution:

* `# Inputs`: contains all mandatory input data callers can provide;
* `# Intent`: contains a description of the role the agent must assume and the details driving its job;
* `# Rules`: contains all rules that the agent must follow.