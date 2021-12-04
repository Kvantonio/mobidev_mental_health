# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Problem.create(title: 'Depression')
Problem.create(title: 'Irritability')
Problem.create(title: 'Stress')
Problem.create(title: 'Anxiety')


User.create(name: 'Vlad', email: 'kvantonio@i.ua', password: 'Ab12345678', age: 20, gender: 'male',
            about: 'I fill depressed from frontend programming')
User.create(name: 'Test', email: 'Test@gmail.com', password: 'Test1234', age: 100, gender: 'female',
            about: 'TestTestTestTestTest')
