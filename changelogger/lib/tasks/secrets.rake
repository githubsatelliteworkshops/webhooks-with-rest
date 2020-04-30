task :add_secrets, [:key_value] => [:environment] do |t, args|
  key, value = args[:key_value].split('=')

  Rails.application.credentials.change do |tmp_path|
    File.open(tmp_path, 'a') do |f|
      f << "#{key}: #{value}\n"
    end
  end
end
