#coding: utf-8

if defined? Tire
  Tire.configure { logger File.join('log','elasticsearch.log') }
end

module Tire
  def synonym_analysis
    {
      analyzer: {
          synonym_analyzer: {
              filter: ["standard","lowercase","mysnow"],
              type: "custom",
              tokenizer: "standard" }
      },
      filter: {
          mysynonyms: { type: "synonym", synonyms: [""] },
          myngrams: { side: "front", max_gram: 5, min_gram: 1, type: "edgeNGram" },
          mysnow: { type: "snowball", language: "Russian", stopwords: russian_stopwords }
      }
    }
  end
  
  def russian_stopwords
    %w(в во не что он на я с со как а то все она так его но да ты к у же вы за бы по только ее мне было вот от меня еще нет о из ему теперь когда даже ну вдруг ли еси уже или ни быть был него до вас нибудь опять уж вам сказал ведь там потом себя ничего ей может они тут где есть надо ней для мы тебя их чем была сам чтоб без будто человек чего раз тоже себе под жизнь будет ж тогда кто этот говорил того потому этого какой совсем ним здесь этом один почти мой тем чтобы нее кажется сейчас были куда зачем сказать всех никогда сегодня можно при наконец два об другой хоть после над больше тот через эти нас про всего них какая много разве сказала три эту моя впрочем хорошо свою этой перед иногда лучше чуть том нельзя такой им более всегда конечно всю между)
  end

  module_function :synonym_analysis, :russian_stopwords
end
