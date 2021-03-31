GROUP_SIZE = 10_000

def main
  movies_json = JSON.parse(open("db/imdb_movies.json").read)
  titles_cache = {}
  participants_cache = {}

  ActiveRecord::Base.transaction do
    group_num = 0
    movies_json.in_groups_of(GROUP_SIZE) do |movie_group|
      group_num += 1

      titles = create_titles(movie_group, group_num)
      participants = create_participants(movie_group, group_num)

      titles.each { |title| titles_cache[title["title"]] = title }
      participants.each { |participant| participants_cache[participant["full_name"]] = participant }
      create_appearances(movie_group, titles_cache, participants_cache, group_num)
    end
  end

  puts "🏁 Successfully finished creating records"
  puts "  🎥 Titles: #{ActiveSupport::NumberHelper.number_to_delimited(Title.count)}"
  puts "  👤 Participants: #{ActiveSupport::NumberHelper.number_to_delimited(Participant.count)}"
  puts "  🎭 Appearances: #{ActiveSupport::NumberHelper.number_to_delimited(Appearance.count)}"
end

def create_titles(movie_group, group_num)
  titles = get_titles(movie_group)
  titles = Title.insert_all(titles, returning: %i[id title])
  print_created("titles", group_num)

  titles
end

def create_participants(movie_group, group_num)
  participants = get_participants(movie_group)
  participants = Participant.insert_all(participants, returning: %i[id full_name])
  print_created("participants", group_num)

  participants
end

def create_appearances(movie_group, titles, participants, group_num)
  appearances = get_appearances(movie_group, titles, participants)
  Appearance.insert_all(appearances)
  puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} appearances records...."

  appearances
end

def print_created(record_type, group_num)
  puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} #{record_type} records...."
end

def get_titles(movie_group)
  movie_group.map do |movie|
    next nil unless movie

    serialize_title(movie)
  end.compact
end

def serialize_title(movie)
  {
    title: movie["title"],
    type: "Movie",
    year: movie["year"],
    image_url: movie["image"],
    color: movie["color"],
    score: movie["score"],
    rating: movie["rating"],
    **dates
  }
end

def get_participants(movie_group)
  movie_group.map do |movie|
    next nil unless movie

    movie["actors"].map { |actor_full_name| serialize_participant(actor_full_name) }
  end.compact.flatten
end

def get_appearances(movie_group, titles, participants)
  movie_group.map do |movie|
    next nil unless movie

    movie_title = movie["title"]
    movie["actors"].map { |actor_full_name| serialize_appearance(actor_full_name, movie_title, titles, participants) }
  end.compact.flatten
end

def serialize_appearance(actor_full_name, movie_title, titles, participants)
  participant = participants[actor_full_name]
  title = titles[movie_title]

  {
    participant_id: participant["id"],
    title_id: title["id"],
    role: :actor,
    **dates
  }
end

def serialize_participant(actor_full_name)
  first_name, last_name = actor_full_name.split(' ', 2)

  {
    full_name: actor_full_name,
    first_name: first_name,
    last_name: last_name,
    **dates
  }
end

# needed by insert_all since it doesn't use life-cycle hooks
def dates
  {
    created_at: Time.zone.now,
    updated_at: Time.zone.now
  }
end

def measure_time
  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  yield
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  ending - starting
end

puts "\n⏱  Completed in #{measure_time(&method(:main))} seconds"
