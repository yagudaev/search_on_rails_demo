GROUP_SIZE = 10_000
movies_json = JSON.parse(open("db/imdb_movies.json").read)

ActiveRecord::Base.transaction do
  group_num = 0
  movies_json.in_groups_of(GROUP_SIZE) do |movie_group|
    group_num += 1
    data = movie_group.map do |movie|
      return nil unless movie

      {
        title: movie["title"],
        type: "Movie",
        year: movie["year"],
        image_url: movie["image"],
        color: movie["color"],
        score: movie["score"],
        rating: movie["rating"],

        # needed by insert_all since it doesn't use life-cycle hooks
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end.compact
    Title.insert_all(data)

    puts "Created #{ActiveSupport::NumberHelper.number_to_delimited(group_num * GROUP_SIZE)} movie records...."
  end
end

puts "🏁 Successfully finished creating records"
