resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    "@vrp/lib/utils.lua",
    "nui.lua"
}
server_scripts {
    "@vrp/lib/utils.lua",
    "server.lua"
}

ui_page "html/index.html"
files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
    'html/logo.png'
}