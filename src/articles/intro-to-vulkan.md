When I started learning Vulkan in early 2026, I found that most tutorials were implementation focused and filled with verbose code. When learning something new, I like to start with a high-level overview before diving in to implementation details. This is my attempt to create the tutorial I wish I had.

Vulkan code can be intimidating, but the underlying concepts are simple. Once you understand how the system works, it becomes a lot easier to understand the code.

This article covers the concepts that are central to any Vulkan program. Future articles will cover specifics like compute, rendering, and raytracing.

A basic understanding of realtime computer graphics is assumed. I recommend you start with [Intro to Realtime Computer Graphics](./todo.html) if you're new to GPU programming.

Let's start from the beginning.

## What is Vulkan?

Vulkan is a graphics API. A graphics API is an interface for controlling GPUs.

//TODO

## Resources

### Buffers

Buffers are spans of linear memory. Any non-image data lives in buffers. Shaders can read from and write to buffers, the CPU can copy data to/from buffers, and buffers are used to pass data by reference to certain commands.

Storage Buffers are generic unstructured buffers that shaders read from or write to.

//TODO Uniform Buffers

### Images

Images are structured blocks of memory. Images have a format and dimensions. They are optimized for typical image data use cases such as sampling and can be used as render targets for rasterization.

Sampled Images are read-only views of underlying image data that can be read in shaders. The Sampler resource used to read an image controls how the data is read - mainly filtering (point vs bilinear) and out-of-bounds behavior (clamp, wrap, mirror).

Storage Images are similar to Storage Buffers. They can be read from or written to by a shader, and Vulkan handles the value encoding/decoding from floating point numbers to/from the image's format.

### Opaque Resources

There are a number of "opaque" resources, meaning resources you don't interact with directly but are used by Vulkan.

//TODO Image Samplers

//TODO Descriptors

//TODO Acceleration Structures

## Shaders

A shader is a program that runs on the GPU. The name is an artifact from the early days of GPU programming where all they could do was calculate fragment colors as part of an otherwise fixed-function pipeline. Today, shaders can do all sorts of computation outside of just rendering.

Unlike other graphics APIs, Vulkan is shader language agnostic. Instead, Vulkan uses SPIR-V, an intermediate representation (IR) bytecode format. Shader languages such as GLSL or HLSL can be compiled to SPIR-V. I like using Slang, a new-ish shading language originally developed by Nvidia and now managed by Khronos Group. The syntax is similar to C++ and it has great support for modern graphics API features.

Shaders are compiled and linked into a Program. For rasterization pipelines, a minimal program consists of a vertex shader and a fragment shader.

## Pipelines

A Pipeline is what is actually executed on the GPU. It consists of a Program and a bunch of configuration. There are several types of Pipelines.

Compute Pipelines execute a compute shader. This is the most basic type. There are no required inputs or outputs and the configuration is minimal.

Rasterization Pipelines execute a vertex shader, fragment shader, and optionally geometry and tesselation shaders (though these are becoming much less common over time). In addition to the programmable shader stages, there are a number of fixed-function stages

## Wrapping Up

This overview is not exhaustive. Vulkan has a lot of features that make it flexible enough for practically any use case. I just focused on the ones typically used for realtime rendering/computation for PC platforms.

## Next Steps

For a hands-on coding tutorial, I recommend [How to Vulkan in 2026](https://www.howtovulkan.com/) by Sascha Willems. It walks you through the process of building a minimal Vulkan 3D renderer with no abstractions.

Go forth and render!
