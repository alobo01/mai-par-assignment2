# action_tree_visualization.py
import random
import re
import networkx as nx
import matplotlib.pyplot as plt

def parse_action_tree(input_text, remove_move=False):
    # Dictionary to store parsed data
    action_tree = {}

    # Regex patterns to match required components
    node_pattern = r"PathNode{GenericState}\((0x[0-9a-f]+)"
    linked_ref_pattern = r"LinkedNodeRef\((0x[0-9a-fA-F]+),\s*(.+?)\)"

    # Split the input text into separate nodes for parsing
    nodes = input_text.split("\n\n\n")
    preReferencesMoveActions = {}
    for node_text in nodes:
        # Find the main node ID
        main_node_match = re.search(node_pattern, node_text)
        if main_node_match:
            node_id = main_node_match.group(1)
        else:
            continue



        # Initialize dictionary for this node
        action_tree[node_id] = {"prev_node": None, "action": "Root Node"}
        
        # Find linked node reference and action
        linked_ref_match = re.search(linked_ref_pattern, node_text)
        if linked_ref_match:
            prev_node = linked_ref_match.group(1)
            action = linked_ref_match.group(2)

            # If `remove_move` is True and the action contains "move", skip this node
            if remove_move and "move" in action.lower():
                if prev_node in preReferencesMoveActions:
                    preReferencesMoveActions[node_id] = preReferencesMoveActions[prev_node]
                else:
                    preReferencesMoveActions[node_id] = prev_node
                del action_tree[node_id]
                continue


            # Check if node references itself, making it a root node
            if prev_node == node_id:
                prev_node = None  # Set as None if it's a root

            # Update node details in dictionary
            if remove_move and prev_node in preReferencesMoveActions:
                action_tree[node_id]["prev_node"] = preReferencesMoveActions[prev_node]
                action_tree[node_id]["action"] = action
            else:
                action_tree[node_id]["prev_node"] = prev_node
                action_tree[node_id]["action"] = action

    return action_tree

def hierarchy_pos(G, root=None, width=1., vert_gap = 0.2, vert_loc = 0, xcenter = 0.5):

    '''
    From Joel's answer at https://stackoverflow.com/a/29597209/2966723.  
    Licensed under Creative Commons Attribution-Share Alike 
    
    If the graph is a tree this will return the positions to plot this in a 
    hierarchical layout.
    
    G: the graph (must be a tree)
    
    root: the root node of current branch 
    - if the tree is directed and this is not given, 
      the root will be found and used
    - if the tree is directed and this is given, then 
      the positions will be just for the descendants of this node.
    - if the tree is undirected and not given, 
      then a random choice will be used.
    
    width: horizontal space allocated for this branch - avoids overlap with other branches
    
    vert_gap: gap between levels of hierarchy
    
    vert_loc: vertical location of root
    
    xcenter: horizontal location of root
    '''
    if not nx.is_tree(G):
        raise TypeError('cannot use hierarchy_pos on a graph that is not a tree')

    if root is None:
        if isinstance(G, nx.DiGraph):
            root = next(iter(nx.topological_sort(G)))  #allows back compatibility with nx version 1.11
        else:
            root = random.choice(list(G.nodes))

    def _hierarchy_pos(G, root, width=1., vert_gap = 0.2, vert_loc = 0, xcenter = 0.5, pos = None, parent = None):
        '''
        see hierarchy_pos docstring for most arguments

        pos: a dict saying where all nodes go if they have been assigned
        parent: parent of this branch. - only affects it if non-directed

        '''

        if pos is None:
            pos = {root:(xcenter,vert_loc)}
        else:
            pos[root] = (xcenter, vert_loc)
        children = list(G.neighbors(root))
        if not isinstance(G, nx.DiGraph) and parent is not None:
            children.remove(parent)  
        if len(children)!=0:
            dx = width/len(children) 
            nextx = xcenter - width/2 - dx/2
            for child in children:
                nextx += dx
                pos = _hierarchy_pos(G,child, width = dx, vert_gap = vert_gap, 
                                    vert_loc = vert_loc-vert_gap, xcenter=nextx,
                                    pos=pos, parent = root)
        return pos

            
    return _hierarchy_pos(G, root, width, vert_gap, vert_loc, xcenter)

def visualize_action_tree(data):
    G = nx.DiGraph()  # Directed graph

    # Adding edges to the graph based on previous node relationships
    for node, info in data.items():
        prev_node = info["prev_node"]
        action = info["action"]

        if prev_node:
            G.add_edge(prev_node, node, action=action)
        else:
            root = node
            G.add_node(node)  # Root node

    # Setting up a tree-like position layout for depth visualization
    pos = hierarchy_pos(G, root, width=20, vert_gap=0.5)  # Increase width and vert_gap for spacing
    edge_labels = {(u, v): d['action'] for u, v, d in G.edges(data=True)}

    # Drawing the graph with node labels and edge action labels
    nx.draw(G, pos, with_labels=False, node_size=100, node_color="lightblue", font_size=8, font_weight="bold")
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color="black", font_size=7)

    # Display the plot
    plt.title("Action Tree Visualization")
    plt.show(block=True)


input_text = open("julia/tree.txt","r").read()
data = parse_action_tree(input_text,remove_move=True)
# Visualize the action tree with the provided data
visualize_action_tree(data)