# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160318072133) do

  create_table "administrators", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "administrators", ["course_id"], name: "index_administrators_on_course_id"
  add_index "administrators", ["user_id"], name: "index_administrators_on_user_id"

  create_table "assignments", force: :cascade do |t|
    t.integer "course_id"
    t.string  "resource_link_id"
  end

  add_index "assignments", ["course_id"], name: "index_assignments_on_course_id"
  add_index "assignments", ["resource_link_id"], name: "index_assignments_on_resource_link_id"

  create_table "courses", force: :cascade do |t|
    t.string "context_id"
    t.string "name"
  end

  add_index "courses", ["context_id"], name: "index_courses_on_context_id"

  create_table "graders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "graders", ["course_id"], name: "index_graders_on_course_id"
  add_index "graders", ["user_id"], name: "index_graders_on_user_id"

  create_table "staffs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "staffs", ["course_id"], name: "index_staffs_on_course_id"
  add_index "staffs", ["user_id"], name: "index_staffs_on_user_id"

  create_table "students", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.integer "grader_id"
  end

  add_index "students", ["course_id"], name: "index_students_on_course_id"
  add_index "students", ["grader_id"], name: "index_students_on_grader_id"
  add_index "students", ["user_id"], name: "index_students_on_user_id"

  create_table "submissions", force: :cascade do |t|
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.boolean  "submitted",                                             default: false
    t.datetime "submitted_at"
    t.integer  "graded_by_id"
    t.decimal  "grade",                         precision: 8, scale: 8, default: 0.0
    t.datetime "graded_at"
    t.text     "description"
    t.text     "lti_params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "student_document_file_name"
    t.string   "student_document_content_type"
    t.integer  "student_document_file_size"
    t.datetime "student_document_updated_at"
    t.string   "grader_document_file_name"
    t.string   "grader_document_content_type"
    t.integer  "grader_document_file_size"
    t.datetime "grader_document_updated_at"
  end

  add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id"
  add_index "submissions", ["graded_by_id"], name: "index_submissions_on_graded_by_id"
  add_index "submissions", ["student_id"], name: "index_submissions_on_student_id"
  add_index "submissions", ["submitted"], name: "index_submissions_on_submitted"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
