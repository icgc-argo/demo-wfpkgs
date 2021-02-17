# Demo Nextflow Workflow Packages

This repository demonstrates the modular approach we propose on how to organize and develop
[Nextflow](https://www.nextflow.io/) workflows via shareable and reusable packages using
the WFPM CLI tool (https://github.com/icgc-argo/wfpm).

This is a simplified version of the ARGO DNA Alignment Workflow (https://github.com/icgc-argo/dna-seq-processing-wfs). However the underlying
tools `bwaMemAligner`, `bamMergeSortMarkdup` and `cleanupWorkdir` are mostly the same (much of the
code was simply copied over here) as the ARGO productoin workflow.

## Workflow Diagram

![](https://raw.githubusercontent.com/icgc-argo/demo-wfpkgs/_to_be_updated_/workflow-diagram.png)
