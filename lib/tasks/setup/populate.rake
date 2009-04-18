PATHS = {
  :photos => {
    :root => "/usr/share/pixmaps/backgrounds/",
    :files => "*/**"
  },
  :audios => {
    :root => "/home/atd/almacen/musica/grupete",
    :files => "*"
  },
  :documents => {
    :root => "/home/atd/teleco/articulos_propios",
    :files => "**/*"
  }
}

namespace :setup do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller/test_process'

    User.destroy_all
    Group.destroy_all
    Article.destroy_all
    Photo.destroy_all
    Audio.destroy_all
    Document.destroy_all
    Uri.destroy_all
    Bookmark.destroy_all
    Performance.destroy_all

    def random_file(type)
      path = PATHS[type]
      files = Dir[File.join(path[:root], path[:files])]

      while true
        file = files.rand
        mime = `file -b --mime-type '#{ file }'`.chomp
        puts "#{ type } try: #{ file } (#{ mime })"
        next if test(?d, file)
        tmp_file = ActionController::TestUploadedFile.new(file, mime)
        break if type.to_class.accepts.include?(mime)
      end
      puts "done"
      tmp_file
    end

    def comments(resources)
      return if rand > 0.2

      users = User.all

      resources.each do |r|
        Comment.populate 1..10 do |comment|
          comment.commentable_id = r.id
          comment.commentable_type = r.class.base_class.to_s
          author = users.rand
          comment.author_id = author.id
          comment.author_type = author.class.base_class.to_s
          comment.content = Populator.sentences(1..4)
          comment.created_at = r.created_at..Time.now
          comment.updated_at = comment.created_at..Time.now
        end
      end
    end

    def articles(owner, authors)
      Article.populate 10..100 do |article|
        content_fields(article, owner, authors)

        article.body = Populator.sentences(3..15)
      end

      comments(owner.articles)
    end

    def photos(owner, authors)
      return if rand > 0.1

      Photo.populate 2..4 do |photo|
        content_fields(photo, owner, authors)
      end

      owner.photos.each do |photo|
        photo.media = random_file(:photos)
        photo.save!
      end

      comments(owner.photos)
    end

    def audios(owner, authors)
      return if rand > 0.1

      Audio.populate 1..2 do |audio|
        content_fields(audio, owner, authors)
      end

      owner.audios.each do |audio|
        audio.media = random_file(:audios)
        audio.save!
      end

      comments(owner.audios)
    end

    def documents(owner, authors)
      return if rand > 0.3

      Document.populate 1..3 do |document|
        content_fields(document, owner, authors)
      end

      owner.documents.each do |document|
        document.media = random_file(:documents)
        document.save!
      end

      comments(owner.documents)
    end

    def bookmarks(owner, authors)
      Bookmark.populate 5..30 do |bookmark|
        content_fields(bookmark, owner, authors)

        bookmark.uri_id = Uri.find_or_create_by_uri("http://#{ Faker::Internet.domain_name }").id
      end

      comments(owner.bookmarks)
    end

    def contents(owner, authors)
      articles(owner, authors)
      photos(owner, authors)
      audios(owner, authors)
      bookmarks(owner, authors)
      documents(owner, authors)
    end

    def content_fields(content, owner, authors)
      content.title = Populator.words(1..4).titleize
      content.description = Populator.sentences(0..2)
      content.created_at = 3.years.ago..Time.now
      content.updated_at = content.created_at..Time.now
      content.public_read = [ true, false ]

      content.owner_id = owner.id
      content.owner_type = owner.class.base_class.to_s

      author = authors.rand
      content.author_id = author.id
      content.author_type = author.class.base_class.to_s
#        post.tag_with Populator.words(1..4).gsub(" ", ",")
    end

    User.populate 35 do |user|
      user.login = Faker::Name.name
      user.email = Faker::Internet.email
      user.crypted_password = User.encrypt("test", "")
      user.activated_at = 2.years.ago..Time.now
      user.description = Populator.sentences(1..2) if [ true, false ].rand
    end

    users = User.all

    users.first(30).each do |user|
      contents(user, Array(user))
    end

    Group.populate 35 do |group|
      group.name = Populator.words(1..3).titleize
      group.description = Populator.sentences(1..2) if [ true, false ].rand
      group.user_id = users.map(&:id)
    end

    users = User.all
    role_ids = Role.find_all_by_stage_type('Group').map(&:id)

    Group.all.each do |group|
      available_users = users.dup

      Performance.populate(3..7) do |performance|
        user = available_users.delete_at((rand * available_users.size).to_i)
        performance.stage_id = group.id
        performance.stage_type = 'Group'
        performance.role_id = role_ids
        performance.agent_id = user.id
        performance.agent_type = 'User'
      end

    end

    Group.all.first(30).each do |group|
      contents(group, User.all)
    end
  end
end
