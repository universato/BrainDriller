class DrillsController < ApplicationController

  def index
    # @drills = Drill.all.order(number_of_problems: "DESC")
    @drills = Drill.order(created_at: "DESC").page(params[:page]).includes(:drill_problems)
  end

  def show
    @drill = Drill.find_by(id: params[:id])
    @drill.increment!(:number_of_views, 1)
    @problems = @drill.problems
  end

  def new
    @drill = Drill.new

    # [Rails]ransackを利用した色々な検索フォーム作成方法まとめ - Qiita https://qiita.com/nishina555/items/2c1f8bae980e426519bc
    @search = Problem.ransack(params[:q])
    @problems = @search.result(distinct: true)

    # 【Rails】kaminari&ransackでページネーションと検索機能を実装 - Qiita https://qiita.com/hiro266/items/809a26fed8a962851417
    # @problems = Problem.includes(:user).page(params[:page])
    # @problems = Problem.page(params[:page])
    @q = Problem.ransack(params[:q]) # 検索オブジェクト作成
    @problems = @q.result.page(params[:page]) # 検索結果(検索しなければ全件取得)

    @search = Problem.ransack(params[:q])
    @problems = @search.result(distinct: true)

    # Ransackで簡単に検索フォームを作る73のレシピ - 猫Rails http://nekorails.hatenablog.com/entry/2017/05/31/173925

    unless params[:q].blank?
      # render json: @problems.select("id").map { |e| e.id  }.to_json
    end
  end

  def create
    @drill = Drill.new(drill_params)
    @drill.number_of_views = 0
    @drill.save!
    render "index"
  end

  def edit
    @drill = Drill.find(params[:id])
  end

  def update
  end

  def solve
    @drill = Drill.find(params[:drill_id])
    @problems = @drill.problems.paginate(page: params[:page], per_page: 1)
    @problem = @problems[0]
  end

  private

    def drill_params
      params.require(:drill).permit(:title)
    end
end
