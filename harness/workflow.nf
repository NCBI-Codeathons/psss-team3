#!/usr/bin/env nextflow

needle = Channel.fromPath( params.needle )

// This would normally be a queue channel
haystack = Channel.value( params.haystack )
haystack_db = Channel.value( params.haystack_db )

process run_tool {
    input:
    path needle from needle
    path haystack from haystack

    output:
    stdout into results

    """
    psss-benchmark ${needle} ${haystack}
    """
}

results.view { "results: $it" }

