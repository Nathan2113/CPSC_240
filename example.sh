#USING USER INPUT
# echo Enter your name

# read name

# echo enter your age

# read age

# echo Enter your job

# read job

# echo "Your information is: $name, $age, $job"

#USING PARAMETERS
# name=$1
# age=$2
# job=$3

# echo "Your information is $name, $age, $job"

#USING ARRAYS
# transport=('car' 'train' 'bike' 'bus')

# #@ means all arguments (i.e. all indices)
# echo "${transport[@]}"

# will print out train (second index)
# echo "${transport[1]}"

# #deletes index 1
# unset transport[1]

# #inserts 'trainride' into index 1
# transport[1]='trainride'

# echo "${transport[@]}"

#CONDITIONALS
# value=3

# guess=$1

# #fi ends if statement
# #YOU NEED SPACES IN IF STATEMENT
# if [ $guess = $value ]
#     then

#     echo "They are equal"
# else
#     echo "They are not equal"
# fi