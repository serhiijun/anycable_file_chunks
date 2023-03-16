require "pathname"
require 'active_support/inflector'
require 'colored'

myapp_path             = Pathname.new("#{Dir.pwd}")
stylesheets_path       = myapp_path.join("app", "assets", "stylesheets")
javascript_path        = myapp_path.join("app", "javascript")
layouts_path           = myapp_path.join("app", "views", "layouts")
css_bentries_path      = stylesheets_path.join("ui", "bentries")
js_bentries_path       = javascript_path.join("ui", "bentries")
layouts_bentries_path  = layouts_path.join("ui", "bentries")

entry_ns               = ARGV[0]
entry_ns_camelized     = entry_ns.split("::").map(&:camelize).join("::")
entry_name             = entry_ns_camelized.split("::").last
entry_path             = entry_ns.split("::").join("/")

full_css_entry_path    = css_bentries_path.join(entry_path.underscore)
full_js_entry_path     = js_bentries_path.join(entry_path.underscore)
full_layout_entry_path = layouts_bentries_path.join(entry_path.underscore)

if full_css_entry_path.exist?
  puts "Entry #{full_css_entry_path.relative_path_from(myapp_path)} already exists".red.bold
else
  full_css_entry_path.mkpath
  css_entry_files = [
    { name: "components.css",         content: "" },
    { name: "components.css.json",    content: "[]" },
    { name: "precomponents.css",      content: "" },
    { name: "precomponents.css.json", content: "[]" },
    { name: "index.css",              content: "@import url(\"./components.css\");" },
  ]
  css_entry_files.each do |file|
    if full_css_entry_path.join(file[:name]).exist?
      puts "File #{full_css_entry_path.join(file[:name]).relative_path_from(myapp_path)} already exists".red.bold
    else
      puts full_css_entry_path.join(file[:name]).to_s.green.bold
      full_css_entry_path.join(file[:name]).open("w") do |f|
        f.write(file[:content])
      end
    end
  end
end

if full_js_entry_path.exist?
  puts "Entry #{full_js_entry_path.relative_path_from(myapp_path)} already exists".red.bold
else
  full_js_entry_path.mkpath
  js_entry_files = [
    { name: "components.js",         content: "" },
    { name: "components.js.json",    content: "[]" },
    { name: "precomponents.js",      content: "" },
    { name: "precomponents.js.json", content: "[]" },
    { name: "index.js",              content: "import \"./components\";"},
  ]
  js_entry_files.each do |file|
    if full_js_entry_path.join(file[:name]).exist?
      puts "File #{full_js_entry_path.join(file[:name]).relative_path_from(myapp_path)} already exists".red.bold
    else
      puts "+ #{full_js_entry_path.join(file[:name]).relative_path_from(myapp_path).to_s}".green.bold
      full_js_entry_path.join(file[:name]).open("w") do |f|
        f.write(file[:content])
      end
    end
  end
end

css_index_path = full_css_entry_path.join("index.css").relative_path_from(stylesheets_path)
js_index_path = full_js_entry_path.join("index.js").relative_path_from(javascript_path)

js_index_directory_path = js_index_path.dirname.to_s
js_index_filename_without_extension = js_index_path.basename('.js').to_s
js_index_formatted_path = "#{js_index_directory_path}/#{js_index_filename_without_extension}"

css_index_directory_path = css_index_path.dirname.to_s
css_index_filename_without_extension = css_index_path.basename('.css').to_s
css_index_formatted_path = "#{css_index_directory_path}/#{css_index_filename_without_extension}"


if full_layout_entry_path.exist?
  puts "Entry #{full_layout_entry_path.relative_path_from(myapp_path)} already exists".red.bold
else
  full_layout_entry_path.mkpath
  layout_entry_files = [
    { name: "index.html.erb", content: "
<!DOCTYPE html>
<html>
  <head>
    <meta name=\"viewport\" content=\"width=device-width,initial-scale=1, maximum-scale=1.0, user-scalable=no\" >
    <%= action_cable_meta_tag %>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= display_meta_tags %>
    <%= stylesheet_link_tag \"#{css_index_formatted_path}\", \"data-turbo-track\": \"reload\" %>
    <%= javascript_include_tag \"#{js_index_formatted_path}\", \"data-turbo-track\": \"reload\", defer: true, type: \"module\" %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
    " },
  ]
  layout_entry_files.each do |file|
    if full_layout_entry_path.join(file[:name]).exist?
      puts "File #{full_layout_entry_path.join(file[:name]).relative_path_from(myapp_path)} already exists".red.bold
    else
      puts "+ #{full_layout_entry_path.join(file[:name]).relative_path_from(myapp_path).to_s}".green.bold
      full_layout_entry_path.join(file[:name]).open("w") do |f|
        f.write(file[:content])
      end
    end
  end
end
