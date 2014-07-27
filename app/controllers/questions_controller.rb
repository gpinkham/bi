class QuestionsController < ApplicationController

  def index
    @tags = Question.tag_counts_on(:tags)
    @questions = Question.order(:created_at).paginate(:page => params[:page])
  end

  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @question.api_info }
    end
  end

  def search
    @questions = Question.basic_search(params[:search][:search_term]).paginate(:page => params[:page])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(questions_params)
    if @question.save
      redirect_to question_path(@question)
    else
      redirect_to new_question_path
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(questions_params)
      flash[:success] = "Question Updated"
      redirect_to question_path(@question)
    else
      render 'edit'
    end
  end

  def destroy
  end

  def tags
    @questions = Question.tagged_with(params[:tag]).paginate(:page => params[:page])
    @tag = params[:tag]
  end

  def add_tag
    @question = Question.find(params[:id])
    @tag = params[:tag]
    @question.tag_list.add(@tag)
    @question.save
  end

  def download_result
    @question = Question.find(params[:id])
    @result = @question.perform(params[:inputs])
    filename = "#{@question.name}_#{Time.now.strftime("%m_%d_%y")}.csv"
    answer = @result.to_csv_data.insert(0, "Question #{@question.id} - #{@question.name} - With Params #{params[:inputs].to_s.gsub(",","")}\n\n")
    send_data answer,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{filename}"
  end

  def result
    @inputs = params[:inputs]
    @question = Question.find(params[:id])
    @result = @question.perform(@inputs)
    @error = @question.error
    respond_to do |format|
      format.html
      format.json { render :json => @result }
    end
  end

  def questions_params
    params.require(:question).permit(:name, :description, :question_sql, :tag_list, :data_source)
  end

end
