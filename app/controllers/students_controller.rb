require 'date'


class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  # GET /students or /students.json
  def index
    @search_params = params[:search] || {}
  
    # Show all students if the "Show All" button was clicked
    if params[:show_all] == 'Show All'
      @students = Student.all
    else
      # Only return no students if both major and date are empty
      if @search_params[:major].blank? && @search_params[:date].blank?
        @students = Student.none
      else
        @students = Student.all
  
        # Filter by major if present
        if @search_params[:major].present?
          @students = @students.where(major: @search_params[:major])
        end
  
        # Filter by date and whether it's before/after if present
        if @search_params[:date].present? && @search_params[:date_before_after].present?
          date_str = @search_params[:date]
          date = Date.parse(date_str)
          date_before_after = @search_params[:date_before_after]
          @students = case date_before_after
                      when 'before'
                        @students.where('graduation_date <= ?', date)
                      when 'after'
                        @students.where('graduation_date >= ?', date)
                      else
                        @students
                      end
        end
      end
    end
  end
  
  
  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :school_email, :major, :minor, :graduation_date, :profile_picture)
    end
  
end
