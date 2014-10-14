namespace :quillwriter do

  desc "create initial activities for writer"
  task :bootstrap => :environment do

    # classification
    ac = ActivityClassification.where(key: 'writer').first_or_create!
    ac.update_attributes(name: 'Quill Writer', key: 'writer', app_name: :writer,
                   module_url: 'http://quill-writer.firebaseapp.com/#/',
                     form_url: 'http://quill-writer.firebaseapp.com/#/form')


    # taxonomy
    section = Section.where(name: 'Quill Writer Activities').first_or_create!
    topic = section.topics.where(name: 'Quill Writer Topics').first_or_create!

    # topic info
    puts "\n\n---- TAXONOMY ----\n"
    ap TopicSerializer.new(topic).as_json


    # activities
    url = "https://raw.githubusercontent.com/empirical-org/Quill-Writer/master/src/common/services/empirical/stories.json"
    data = JSON.parse(RestClient.get(url))

    # remove all activies before
    topic.activities.delete_all

    puts "\n---- ACTIVITIES -----\n\n"

    data.values.each do |act|

      payload = {wordList: act['wordList'].to_json, prompt: act['prompt'].to_json}

      a = topic.activities.create!(name: act['name'], description: act['description'], data: payload, classification: ac)

      ap a.as_json
    end

  end


end
