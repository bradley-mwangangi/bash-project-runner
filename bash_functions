# Bash Functions
# Contains custom Bash functions for enhancing shell functionality.

# run() Function
# Executes project-specific run scripts located within a specified directory structure.
# Handles errors for missing directories and run scripts.
run() {
    # Check if an argument is supplied
    if [ $# -ne 1 ]; then
        echo "Error: Missing or too many arguments. Usage: run path/to/run.sh"
        return 1
    fi

    # projects_dir: parent directory containing all your projects, or just this project
    local projects_dir="$HOME/AllProjectsDir"

    # path_to_project: concatenated full path to the project
    local path_to_project="$projects_dir/$1"

    # Check existence of path_to_project
    if [ -d "$path_to_project" ]; then
        # Check if the run.sh file exists
        if [ -f "$path_to_project/run.sh" ]; then
            # Change directory
            cd "$path_to_project" || return 1

            # Ensure run.sh is executable
            chmod +x "$path_to_project/run.sh"

            # Execute run.sh
            ./run.sh
        else
            echo "Error: 'run.sh' script not found in '$1'"
            return 1
        fi
    else
        local dirs=()
        IFS='/' read -ra dirs <<< "$1"
        local current_dir=""

        # Check each directory level
        for (( i=0; i<${#dirs[@]}; i++ )); do
            current_dir="$current_dir/${dirs[i]}"
            if [ ! -d "$projects_dir$current_dir" ]; then
                echo "Error: Directory '${dirs[i]}' not found"
                return 1
            fi
        done

        return 1
    fi
}
