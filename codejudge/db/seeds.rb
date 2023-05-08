langs = [
  ["none", "", "None"],
  ["assembly", ".as", "Assembly"],
  ["ats", ".dats", "ATS"],
  ["bash", ".sh", "Bash"],
  ["c", ".c", "C"],
  ["clojure", ".clj", "Clojure"],
  ["cobol", ".cob", "COBOL"],
  ["cofeescript", ".coffee", "CoffeeScript"],
  ["cpp", ".cpp", "C++"],
  ["crystal", ".cr", "Crystal"],
  ["csharp", ".cs", "C#"],
  ["d", ".d", "D"],
  ["elixir", ".ex", "Elixir"],
  ["elm", ".elm", "Elm"],
  ["erlang", ".erl", "Erlang"],
  ["fsharp", ".fs", "F#"],
  ["go", ".go", "Go"],
  ["groovy", ".groovy", "Groovy"],
  ["haskell", ".hs", "Haskell"],
  ["idris", ".idr", "Idris"],
  ["java", ".java", "Java"],
  ["javascript", ".js", "Javascript"],
  ["julia", ".jl", "Julia"],
  ["kotlin", ".kt", "Kotlin"],
  ["lua", ".lua", "Lua"],
  ["mercury", ".m", "Mercury"],
  ["nim", ".nim", "Nim"],
  ["nix", ".nix", "Nix"],
  ["ocaml", ".ml", "OCaml"],
  ["perl", ".pl", "Perl"],
  ["php", ".php", "PHP"],
  ["python", ".py", "Python 3"],
  ["raku", ".raku", "Raku"],
  ["ruby", ".rb", "Ruby"],
  ["rust", ".rs", "Rust"],
  ["sac", ".sac", "SaC"],
  ["scala", ".scala", "Scala"],
  ["swift", ".swift", "Swift"],
  ["typescript", ".ts", "TypeScript"],
  ["zig", ".zig", "Zig"]
]

langs.each do |lang|
  Language.create(
    name: lang[0],
    extension: lang[1],
    pretty_name: lang[2]
  )
end

#TEST ROLES
role_admin = Role.create(name: "admin")
role_instructor = Role.create(name: "instructor")
role_ta = Role.create(name: "ta")
role_student = Role.create(name: "student")

#TEST USERS
lok = User.create!(username: "loks", password: "password", password_confirmation: "password", firstname: "lok", lastname: "s", email: "lok@tamu.edu")
lok.assignments.create!(role: role_student)
nachiket = User.create!(username: "nachiket", password: "password", password_confirmation: "password", firstname: "nachiket", lastname: "n", email: "nachiket@tamu.edu")
nachiket.assignments.create!(role: role_student)
druv = User.create!(username: "druv", password: "password", password_confirmation: "password", firstname: "druv", lastname: "g", email: "druv@tamu.edu")
druv.assignments.create!(role: role_student)
nagarjuna = User.create!(username: "nagarjuna", password: "password", password_confirmation: "password", firstname: "nagarjuna", lastname: "k", email: "nagarjuna@tamu.edu")
nagarjuna.assignments.create!(role: role_student)
praveen = User.create!(username: "praveen", password: "password", password_confirmation: "password", firstname: "praveen", lastname: "k", email: "praveen@tamu.edu")
praveen.assignments.create!(role: role_student)
anmol = User.create!(username: "anmol", password: "password", password_confirmation: "password", firstname: "anmol", lastname: "a", email: "anmol@tamu.edu")
anmol.assignments.create!(role: role_student)
ritchey = User.create!(username: "ritchey", password: "password", password_confirmation: "password", firstname: "philip", lastname: "r", email: "philip@tamu.edu")
ritchey.assignments.create!(role: role_instructor)
admin = User.create!(username: "admin", password: "password", password_confirmation: "password", firstname: "Administrator", lastname: "Account", email: "admin@tamu.edu")
admin.assignments.create!(role: role_admin)

(1..10).each do |i|
  DifficultyLevel.create(
    level: i.to_s,
    description: i.to_s
  )
end

DifficultyLevel.create(
  level: "N/A",
  description: "N/A"
)

new_tags = [
    ["Array","Array"],
    ["BFS", "BFS"],
    ["Backtracking", "Backtracking"],
    ["Binary Search","Binary Search"],
    ["DFS","DFS"],
    ["Dynamic Programming","Dynamic Programming"],
    ["Graph","Graph"],
    ["Greedy","Greedy"],
    ["Hash Table","Hash Tables"],
    ["Linked List","Linked Lists"],
    ["Math","Maths"],
    ["Matrix","Matrices"],
    ["Other","Others"],
    ["Queue","Queues"],
    ["Recursion","Recursions"],
    ["Sorting","Sortings"],
    ["Stack","Stacks"],
    ["String","Strings"],
    ["Tree","Trees"],
    ["Two Pointers","Two Pointers"]
]

new_tags.each do |new_tag|
  Tag.create!(
    tag: new_tag[0],
    description: new_tag[1]
  )
end

# Test Classes
ruby_class = Group.create!(
  author_id: "a_1",
  group_title: "Ruby Class",
  description: "This class is for Ruby Course",
  classcode: "xyzasd876"
)

python_class = Group.create!(
  author_id: "a_2",
  group_title: "Python Class",
  description: "This class is for Python Course",
  classcode: "yzasd87"
)


java_class = Group.create!(
  author_id: "a_3",
  group_title: "Java Class",
  description: "This class is for Java Course",
  classcode: "zasd87"
)

cpp_class = Group.create!(
  author_id: "a_4",
  group_title: "cpp Class",
  description: "This class is for cpp Course",
  classcode: "asd87"
)


c_class = Group.create!(
  author_id: "a_5",
  group_title: "c Class",
  description: "This class is for c Course",
  classcode: "sd87"
)