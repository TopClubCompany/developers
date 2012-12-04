#coding: utf-8

module Filter

  def find word
    all.reject{ |f| f[:labels].exclude? word.to_s }
  end

  def all
    filters = [
      { labels: ['Рядом (до 500 м.)','рядом'   ], value: '0.5', type: 'distance' },
      { labels: ['Пройтись (1 км.)' ,'пройтись'], value: '1',   type: 'distance' },
      { labels: ['Проехать (5 км.)' ,'проехать'], value: '5',   type: 'distance' },
      { labels: ['Далеко (10 км.)'  ,'далеко'  ], value: '10',  type: 'distance' },
      { labels: ['Недорого ($)', 'недорого','дешево'         ], value: '0',   type: 'avg_bill'  },
      { labels: ['Неплохо ($$)', 'неплохо'                   ], value: '1',   type: 'avg_bill'  },
      { labels: ['Прилично ($$$)', 'прилично'                ], value: '2',   type: 'avg_bill'  },
      { labels: ['Роскошно ($$$$)','роскошно','восхитительно'], value: '3',   type: 'avg_bill'  }
    ]
  end

  def all_for type
    all.reject{ |f| f[:type].to_s != type.to_s }
  end

  module_function :find, :all, :all_for

end