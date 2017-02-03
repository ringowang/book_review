# Books
class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  def index
    if params[:category].blank?
      @books = Book.all.order('created_at DESC')
    else
      @category_id = Category.find_by(name: params[:category]).id
      @books = Book.where(category_id: @category_id).order('created_at DESC')
    end
  end

  def show
  end

  def new
    @book = current_user.books.build
    # options_for_select([["Dollar", "$"], ["Kroner", "DKK"]])
    # => <option value="$">Dollar</option>
    # => <option value="DKK">Kroner</option>
    # c.name拿来展示, c.id来传值
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def create
    @book = current_user.books.build(book_params)
    @book.category_id = params[:category_id]
    if @book.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def update
    @book.category_id = params[:category_id]
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      render 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to root_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :description, :author, :category_id)
  end

  def find_book
    @book = Book.find(params[:id])
  end
end
