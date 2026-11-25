# Dynamic tokens

Proem defines a custom, dynamic token injection engine that replaces tokens written using a specific syntax, allowing prompts to define more specific and concrete instructions that do not depend on agents judgement and behavior to search for values to be used during their tasks. This is meant to accomplish two different improvements in agents tasks:

* Injecting values available in context directly into their prompts allow instructions to be clearer and more accurate, better guiding agents into the direction writers originally intended;
* AI resources that were to be automatically discoverable do not need to go under such thing, saving all agents upfront context loaded size and thus decrease overall token consumtion from bloated contexts.

## Dynamic token syntax

Dynamic tokens are recognizable in a prompt through the following syntax: `{{resource-type:name}}`. `resource-type` must be exactly one of these values: `parameter`, `role` or `rule`. `name` is the identifying name of the desired resource type value, and can be extracted as follows depending on the token's `resource-type`:

* *parameter* - read from a run manifest
* *role* - file name (without extension) from `roles` folder
* *rule* - file name (without extension) from `rules` folder