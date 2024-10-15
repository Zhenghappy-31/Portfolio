bmi = 0
print("""BMI \t\tClassification \tHealth Risk

Under 18.5 \tUnderweight \tMinimal
18.5 - 24.9 \tNormal Weight \tMinimal
25 - 29.9 \tOverweight \tIncreased
30 - 34.9 \tObese \t\tHigh
35 - 39.9 \tSeverely Obese \tVery High
40 and over \tMorbidly Obese \tExtremely High""")
print("\n-----------------------------------------\n")
weight = int(input("Please enter weight in pounds: "))
height = int(input("Please enter height in inches: "))
bmi = round((weight * 703)/(height * height),2)
print("The BMI is: " + str(bmi))
print("\n-----------------------------------------\n")
if (bmi > 0):
    if (bmi <18.5):   
        print("Classification: Underweight! Health Risk is Minimal!")
    elif (bmi <= 24.9):
        print("Classification: Normal Weight! Health Risk is Minimal!")
    elif (bmi <= 29.9):
        print("Classification: Overweight! Health Risk is Increased!")
    elif (bmi <= 34.9):
        print("Classification: Obese! Health Risk is High!")
    elif (bmi <= 39.9):
        print("Classification: Severely Obese! Health Risk is Very High!")
    else:
        print("Classification: Morbidly Obese! Health Risk is Extremely High!")
else:
    print("Invalid input.")
