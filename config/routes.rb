require_all 'app/controllers/**/*.rb'
require_all 'app/middlewares/**/*.rb'

middleware Middleware::AdminFetcher, as: 1
middleware Middleware::LoginChecker, as: 2

command '/start',               controller: App::StartController

command '/login',               controller: App::AdminController,          action: :commence
command '/logout',              controller: App::AdminController,          action: :logout
command '/exit',                controller: App::AdminController,          action: :exit

command '/product',             controller: App::ProductController
command '/product_add',         controller: App::ProductController,        action: :create
command '/product_show',        controller: App::ProductController,        action: :read
command '/product_edit',        controller: App::ProductController,        action: :update
command '/product_name',        controller: App::ProductController,        action: :name
command '/product_description', controller: App::ProductController,        action: :description
command '/product_cost',        controller: App::ProductController,        action: :cost
command '/product_price',       controller: App::ProductController,        action: :price
command '/product_stock',       controller: App::ProductController,        action: :stock
command '/product_landscape',   controller: App::ProductController,        action: :landscape
command '/product_images',      controller: App::ProductController,        action: :images
command '/product_delete',      controller: App::ProductController,        action: :destroy

command :default,               controller: App::ForwardController,        action: :forward
