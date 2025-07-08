module ApplicationHelper
    def sanitize_with_hashtags(text)
    # 本文中のハッシュタグをリンクに変換する正規表現
    # 例: #hogehoge を <a href="/hashtags/hogehoge">#hogehoge</a> に変換
      Rails.logger.debug "--- sanitize_with_hashtags called with text: #{text}"

    # 正規表現が正しくハッシュタグを抽出しているか確認
    extracted_hashtags = text.scan(/[#＃]([A-Za-z0-9_]+)/)
    Rails.logger.debug "--- Extracted hashtags: #{extracted_hashtags.inspect}"

    result = text.gsub(/[#＃]([A-Za-z0-9_]+)/) do |match|
      name = match.delete('#').delete('＃').downcase
      Rails.logger.debug "--- Processing hashtag name: #{name}"

      hashtag = Hashtag.find_by(name: name)
      Rails.logger.debug "--- Hashtag found? #{hashtag.present?}. Hashtag object: #{hashtag.inspect}"

      if hashtag
        link = link_to "##{name}", hashtag_path(hashtag), class: "hashtag-link"
        Rails.logger.debug "--- Generated link: #{link}"
        link
      else
        Rails.logger.debug "--- Hashtag not found for name: #{name}. Returning original match."
        match
      end
    end

    Rails.logger.debug "--- Final result: #{result.inspect}"
    result.html_safe
    end
end
