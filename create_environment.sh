#!/bin/bash

# this below pops up a message asking for your name. Whatever you type, it remembers it,This helps make everything that follows personal to you
echo ""
read -p "Enter you name: " Name

# This keeps everything organized and tidy, so your reminder system files don't just spread out everywhere.
base_dr="submission_reminder_${Name}"
mkdir -p "${base_dr}"

#Create required directory structure: app, modules, assets, and config folders inside base_dr
mkdir -p "${base_dr}/app" && mkdir -p "${base_dr}/modules" && mkdir -p "${base_dr}/assets" && mkdir -p "${base_dr}/config"

#above is a  way the script uses to write another script directly into the app folder.
cat > "${base_dr}/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#Just like with the main reminder script, this part starts writing the functions.sh file into the modules folder.
cat > "${base_dr}/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#Create a submissions text file listing students, assignments, and their submission status
cat > "${base_dr}/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Emmy, Shell Redirections, not submitted
Marieanne, Shell consoles, not submitted
Brianne, Shell Navigation, not submitted
Perry, Shell Basics, submitted
Jackson, Shell Filters,not  submitted
Gai, Shell Navigation, not submitted
Peterson, Shell Basics, submitted
EOF

# Create a config file that defines the target assignment and number of days remaining
cat > "${base_dr}/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#Make all .sh scripts in the base directory and subdirectories executable
cat > "${base_dr}/startup.sh" << 'EOF'
#!/bin/bash
./app/reminder.sh
EOF

find "${base_dr}" -type f -name "*.sh" -exec chmod +x {} \;


