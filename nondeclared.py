import itertools

def generate_combinations(items, statuses, locations):
    # Generate all combinations of items, statuses, and locations
    return list(itertools.product(items, statuses, locations))

def read_pddl_file(filename):
    with open(filename, 'r') as file:
        return file.readlines()

def write_pddl_file(filename, lines):
    with open(filename, 'w') as file:
        file.writelines(lines)

def extract_objects(pddl_lines):
    items = []
    statuses = []
    locations = []
    objects_section = False

    for line in pddl_lines:
        if '(:objects' in line:
            objects_section = True
        elif objects_section:
            if '-' in line:
                parts = line.split('-')
                obj_type = parts[1].strip()
                objs = parts[0].strip().split()
                if obj_type == 'ingredient' or obj_type == 'dish' or obj_type == 'tool':
                    items.extend(objs)
                elif obj_type == 'status':
                    statuses.extend(objs)
                elif obj_type == 'location':
                    locations.extend(objs)
            if ')' in line:
                objects_section = False
                break  # Exit after objects are read

    return items, statuses, locations

def extract_existing_combinations(pddl_lines):
    existing_combinations = set()
    for line in pddl_lines:
        if '(= (item-count' in line:
            parts = line.split()
            item = parts[2]
            status = parts[3]
            location = parts[4].replace(')', '')
            existing_combinations.add((item, status, location))
    return existing_combinations

def append_missing_combinations(pddl_lines, items, statuses, locations, existing_combinations):
    all_combinations = generate_combinations(items, statuses, locations)
    new_lines = []
    for comb in all_combinations:
        if comb not in existing_combinations:
            item, status, location = comb
            new_line = f'    (= (item-count {item} {status} {location}) 0)\n'
            new_lines.append(new_line)

    # Insert the new lines just before the goal section
    goal_index = next(i for i, line in enumerate(pddl_lines) if ';;ENDOFINIT' in line)
    pddl_lines = pddl_lines[:goal_index] + new_lines + pddl_lines[goal_index:]

    return pddl_lines

def complete_combinations_in_pddl(filename):
    pddl_lines = read_pddl_file(filename)
    items, statuses, locations = extract_objects(pddl_lines)
    existing_combinations = extract_existing_combinations(pddl_lines)
    updated_pddl_lines = append_missing_combinations(pddl_lines, items, statuses, locations, existing_combinations)
    write_pddl_file(filename, updated_pddl_lines)
    print(f"Completed combinations and updated file: {filename}")

# Usage:
filename = "julia/problem.pddl"
complete_combinations_in_pddl(filename)
