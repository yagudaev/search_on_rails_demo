GROUP_SIZE = 10_000

def main
  movies_json = JSON.parse(open("db/imdb_movies.json").read)

  ActiveRecord::Base.transaction do
    group_num = 0
    movies_json.in_groups_of(GROUP_SIZE) do |movie_group|
      group_num += 1

      titles = get_titles(movie_group)
      titles_db = Title.insert_all(titles, returning: %i[id title])
      puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} title records...."

      participants = get_participants(movie_group)
      participants_db = Participant.insert_all(participants, returning: %i[id full_name])
      puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} participant records...."

      appearances = get_appearances(movie_group, titles_db, participants_db)
      Appearance.insert_all(appearances)
      puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} appearances records...."
    end
  end

  puts "🏁 Successfully finished creating records"
  puts "  🎥 Titles: #{Title.count}"
  puts "  👤 Participants: #{Participant.count}"
  puts "  🎭 Appearances: #{Appearance.count}"
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
  participant = participants.find { |record| record["full_name"] == actor_full_name }
  participant ||= Participant.find_by!(full_name: actor_full_name)

  {
    participant_id: participant["id"],
    title_id: titles.find { |record| record["title"] == movie_title }["id"],
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

main
