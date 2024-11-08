#!/usr/bin/env julia

using Graphs
using Plots

# Function to parse the tree structure
function parse_tree_data(file_path::String)
    nodes = Dict{String, Vector{String}}()  # Dictionary to hold parent-child relationships
    parents = Dict{String, String}()         # To track parent nodes
    
    open(file_path, "r") do file
        for line in eachline(file)
            if startswith(line, "SymbolicPlanners.PathNode")
                # Extract node identifier (e.g., 0xa084eaed7be71401)
                node_id = match(r"0x[a-fA-F0-9]+", line).match
                # Extract parent node id
                parent_id_match = match(r"LinkedNodeRef\((0x[a-fA-F0-9]+)", line)
                if parent_id_match !== nothing
                    parent_id = parent_id_match.captures[1]
                    if !haskey(nodes, parent_id)
                        nodes[parent_id] = String[]
                    end
                    push!(nodes[parent_id], node_id)
                    parents[node_id] = parent_id
                else
                    # Handle root node case if needed
                    if !haskey(nodes, "root")
                        nodes["root"] = String[]
                    end
                    push!(nodes["root"], node_id)
                end
            end
        end
    end
    
    return nodes, parents
end

# Function to create a graph from the parsed data
function create_graph(nodes::Dict{String, Vector{String}}, parents::Dict{String, String})
    g = SimpleDiGraph()
    
    # Add vertices
    for node_id in keys(nodes)
        add_vertex!(g, node_id)
    end
    
    # Add edges
    for (parent, children) in nodes
        for child in children
            add_edge!(g, parent, child)
        end
    end
    
    return g
end

# Function to plot the graph and save it as a PNG file
function plot_graph(g::SimpleDiGraph, output_file::String)
    # Set the layout and colors
    plot(g, node_color=:lightblue, edge_color=:gray, 
         title="Tree Structure", markersize=10, legend=false)
    
    savefig(output_file)
end

# Main function to orchestrate the process
function main(file_path::String, output_file::String)
    nodes, parents = parse_tree_data(file_path)
    g = create_graph(nodes, parents)
    plot_graph(g, output_file)
end

# Check for command line arguments and execute the main function
if length(ARGS) != 2
    println("Usage: julia tree_visualizer.jl <input_file> <output_file>")
else
    input_file = ARGS[1]
    output_file = ARGS[2]
    main(input_file, output_file)
end
