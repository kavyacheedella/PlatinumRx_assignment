# ============================================================
# PlatinumRx Assignment | Phase 3 - Python Proficiency
# Script 1: Time Converter
# ============================================================
# Goal: Convert an integer number of minutes into a human-
#       readable string like "2 hrs 10 minutes"
# ============================================================


def convert_minutes(total_minutes):
    
    if not isinstance(total_minutes, int) or total_minutes < 0:
        return "Invalid input. Please provide a non-negative integer."

    hours           = total_minutes // 60   # integer division gives hours
    remaining_mins  = total_minutes  % 60   # modulo gives leftover minutes

    
    hr_label = "hr" if hours == 1 else "hrs"

    return f"{hours} {hr_label} {remaining_mins} minutes"



if __name__ == "__main__":
    test_cases = [130, 110, 60, 45, 0, 90, 200, 1440]

    print("=" * 40)
    print("  Time Converter Output")
    print("=" * 40)
    for minutes in test_cases:
        result = convert_minutes(minutes)
        print(f"  {minutes:>5} minutes  -->  {result}")
    print("=" * 40)

   
    print("\nEnter minutes to convert (or 'q' to quit):")
    while True:
        user_input = input("  Minutes: ").strip()
        if user_input.lower() == 'q':
            print("Exiting.")
            break
        try:
            mins = int(user_input)
            print(f"  Result : {convert_minutes(mins)}\n")
        except ValueError:
            print("  Please enter a valid integer.\n")
