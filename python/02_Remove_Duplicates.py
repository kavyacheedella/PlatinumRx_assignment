# ============================================================
# PlatinumRx Assignment | Phase 3 - Python Proficiency
# Script 2: Remove Duplicate Characters from a String
# ============================================================
# Goal: Given a string, remove all duplicate characters and
#       return only the first occurrence of each character,
#       preserving the original order.  Must use a loop.
# ============================================================


def remove_duplicates(input_string):
    
    result = ""                          # start with empty result string

    for char in input_string:            # loop through every character
        if char not in result:           # only add if NOT already in result
            result += char               # append the new unique character


    return result



if __name__ == "__main__":
    test_cases = [
        "programming",
        "hello",
        "aabbcc",
        "abcabc",
        "PlatinumRx",
        "data analyst",
        "mississippi",
        ""
    ]

    print("=" * 50)
    print("  Remove Duplicate Characters")
    print("=" * 50)
    for s in test_cases:
        result = remove_duplicates(s)
        print(f"  Input  : '{s}'")
        print(f"  Output : '{result}'")
        print("-" * 50)

  
    print("\nEnter a string to remove duplicates (or 'q' to quit):")
    while True:
        user_input = input("  String: ")
        if user_input.lower() == 'q':
            print("Exiting.")
            break
        print(f"  Result: '{remove_duplicates(user_input)}'\n")
