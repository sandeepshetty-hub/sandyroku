Sub init()
    m.RowList = m.top.findNode("RowList")
    m.Title = m.top.findNode("Title")
    m.Description = m.top.findNode("Description")
    m.Poster = m.top.findNode("Poster")
    m.RowList.setFocus(true)
    
    m.Video = m.top.findNode("Video")
   ' m.Video.observeField("state", "onVideoStateChanged")
    m.videoContent = createObject("roSGNode", "ContentNode")
    m.RowList.observeField("rowItemSelected", "playVideo")
    
    m.LoadTask = CreateObject("roSGNode", "FeedParser")
    m.LoadTask.observeField("content", "rowListContentChanged")
    m.LoadTask.observeField("mediaIndex", "indexloaded")
    m.LoadTask.control = "RUN" 
    
    m.InputTask=createObject("roSgNode","inputTask")
    m.InputTask.observefield("inputData","handleInputEvent")
    m.InputTask.control="RUN"
    
    m.RowList.observeField("rowItemFocused", "changeContent")
    
    ' DetailsScreen Node with description, Video Player
    m.detailsScreen = m.top.findNode("DetailsScreen")
    
End Sub

    sub indexloaded(msg)
                if type(msg) = "roSGNodeEvent" and msg.getField() = "mediaIndex"
                    m.mediaIndex = msg.getData()
                      ? "m.mediaIndex= "; m.mediaIndex
                end if
                  handleDeepLink(m.global.deeplink)
     end sub
            
         function handleDeepLink(deeplink as object)
              if validateDeepLink(deeplink)
               playVideo( m.mediaIndex[deeplink.id].url)
              end if
          end function
                        
            function validateDeepLink(deeplink as Object) as Boolean
              mediatypes={movie:"movie",episode:"episode",season:"season",series:"series"}
              if deeplink <> Invalid
                ? "mediaType = "; deeplink.type
                ? "contentId = "; deeplink.id
                ? "content= "; m.mediaIndex[deeplink.id].url
                  if deeplink.type <> invalid then
                    if mediatypes[deeplink.type]<> invalid
                      if m.mediaIndex[deeplink.id] <> invalid
                        if m.mediaIndex[deeplink.id].url <> invalid
                          return true
                        end if
                      end if
                    end if
                  end if
              end if
              return false
            end function


Sub rowListContentChanged()
     m.RowList.content = m.LoadTask.content
end Sub

Sub rowListDetailContentChanged()
     m.RowList.content = m.DetailScreen.content
end Sub

sub handleInputEvent(msg)
    ? "in handleInputEvent()"
    if type(msg) = "roSGNodeEvent" and msg.getField() = "inputData"
        deeplink = msg.getData()
        if deeplink <> invalid
            handleDeepLink(deeplink)
        end if
    end if
end sub



Sub playVideo(url = invalid)
m.detailsScreen.visible = "true"
    ? "url= "; url
    if type(url) = "roSGNodeEvent"
        m.videoContent.url = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1]).URL
    else
        m.videoContent.url = url
    end if

    m.videoContent.streamFormat = "mp4"
    keepPlaying = false
    
    m.detailsScreen.content = m.RowList.focusedContent
    m.detailsScreen.setFocus(true)
    m.detailsScreen.visible = "true"

'    m.Video.content = m.videoContent
'    m.Video.visible = "true"
'    m.Video.control = "play"
End Sub

Function onVideoStateChanged(msg as Object)
  if type(msg) = "roSGNodeEvent" and msg.getField() = "state"
      if msg.getData() = "finished"
            m.Video.visible = "false" 
            m.Video.control = "stop"
      end if
  end if
end Function

Sub changeContent()
    contentItem = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])

    m.top.backgroundUri = contentItem.HDPOSTERURL
    m.Title.text = contentItem.Title
    m.Description.text = contentItem.DESCRIPTION
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean 
    if press
        if key = "back" 
        m.Video.visible = "false" 
        m.Video.control = "stop"
        return true
        end if
    end if
end Function
