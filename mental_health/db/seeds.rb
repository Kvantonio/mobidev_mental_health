problem1, problem2, problem3, problem4 = Problem.create([{ title: 'Depression' }, { title: 'Stress' },
                                                         { title: 'Anxiety' }, title: 'Irritability'])

user1 = User.create(name: 'Vlad', email: 'hh@i.ua', password: 'Ab12345678', age: 20, gender: 'male',
            about: 'I fill depressed from frontend programming')
user2 = User.create(name: 'Test', email: 'Test@gmail.com', password: 'Test1234', age: 100, gender: 'female',
                    about: 'TestTestTestTestTest')

coach1 = Coach.create(name: 'TestCoach', email: 'Coach@i.ua', password: 'Ab12345678', age: 20, gender: 'male',
                      about: 'I help to cope with depressed from frontend programming')

technique1 = Technique.create(title: 'Cognitive - Behavioral Therapy',
                              description: 'Elimination of the dependence
                                            of emotions and human behavior on his thoughts.',
                              age_range: 'Age: 25-35 years',
                              gender: 'male', duration: 7)

step1 = Step.create(title: 'What is cognitive behavioral therapy?',
                    body: 'Cognitive behavioral therapy (CBT) is a type of psychotherapy.
 This form of therapy modifies thought patterns in order to change moods and behaviors.
 It’s based on the idea that negative actions or feelings are the result of current distorted beliefs or thoughts,
 not unconscious forces from the past. CBT is a blend of cognitive therapy and behavioral therapy.
 Cognitive therapy focuses on your moods and thoughts. Behavioral therapy specifically targets actions and behaviors.
 A therapist practicing the combined approach of CBT works with you in a structured setting.
 You and your therapist work to identify specific negative thought patterns and behavioral responses to challenging or
 stressful situations. Treatment involves developing more balanced and constructive ways to respond to stressors.
 Ideally these new responses will help minimize or eliminate the troubling behavior or disorder.
 The principles of CBT can also be applied outside of the therapist’s office.
 Online cognitive behavioral therapy is one example.
 It uses the principles of CBT to help you track and manage your depression and anxiety symptoms online.',
                    number: 1)

step2 = Step.create(title: 'What should you do?',
                    body: "Look at this picture and do something.
                           And when you do something,
                           don't forget to do something.",
                    number: 2)

diploma1 = Diploma.create(title: 'New York University, PhD in Psychology')
diploma2 = Diploma.create(title: 'New York University, PhD in Psychology')
experience1 = Experience.create(title: 'Psychologist, ABC company, 12 years')
certificate1 = Certificate.create(title: 'New York/081109, New York University, 2009')

Invitation.create(status: 1, user_id: user1.id, coach_id: coach1.id)
Invitation.create(status: 0, user_id: user2.id, coach_id: coach1.id)

technique1.problems << problem1
technique1.steps << [step1, step2]

coach1.problems << [problem1, problem3]

coach1.diplomas << [diploma1, diploma2]
coach1.experiences << experience1
coach1.certificates << certificate1
user1.problems << problem1
user2.problems << [problem1, problem2]

Recommendation.create(user_id: user1.id, coach_id: coach1.id, technique_id: technique1.id, current_step:0)
