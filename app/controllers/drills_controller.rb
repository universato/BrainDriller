class DrillsController < ApplicationController

  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).per(2)
  end

  def show
    @drill = Drill.find_by(id: params[:id])
    @drill.increment!(:number_of_views, 1)
    @problems = @drill.problems
  end

  def new
    authenticate_user!
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
    # @drill = Drill.new(drill_params)
    # @drill.number_of_views = 0
    # @drill.save!
    # render "index"
    puts "\n" * 2
    pp params
    # 5 + :aaaaaa
    render json: {}
  end

  def edit
    @drill = Drill.find(params[:id])
  end

  def update
  end

  def solving
    puts "\n" * 20
    id = from_problem_id
    # @drill = Drill.find(params[:id])
    # @problems = @drill.problems.paginate(page: params[:page], per_page: 1)
    # @problem = @problems[0]
  end

  private
    def drill_params
      params.require(:drill).permit(:title)
    end

    def from_problem_id
      s = request.referrer
      s && s[/drills\/(\d+)/, 1]
    end
end
