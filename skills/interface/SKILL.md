---
name: interface
description: "Create a markdown file describing the interface of a module"
disable-model-invocation: true
---

Analyze the selected module, how it works, where it is used and especially its interface.
If the module is a single file, crate {filename without extensions}.interface.md
If it's a folder just create interface.md inside that folder.

The goal of the file is to describe the public interface of the module and all information required to use it.
This is so that I can understand the codebase and review it better without reading every file.

Include code blocks containing just the interfaces, like a c# interface class, but without the implementation. Below the interface include any other types that are effectively part of the interface (like input and ouptut structs).
Also explain the functions in the interface. If there are submodules they can get their own code block and their own explanations under their heading, but keep each class (or equivalient) in one code block
Error types don't need do be included but stuff like configs, results and request types should usually be included.
