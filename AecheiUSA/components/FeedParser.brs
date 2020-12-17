
Sub Init()
    m.top.functionName = "loadContent"
End Sub

Sub loadContent()
    bundle=GetContentFeed()
    oneRow = bundle.contentArray
    list = [
        {
            Title:"Row One"
            ContentList : SelectTo(oneRow, 4)
        }
        {
            Title:"Row Two"
            ContentList : SelectTo(oneRow, 5, 3)
        }
        {
            Title:"Row Three"
            ContentList : SelectTo(oneRow, 5, 8)
        }
        {
            Title:"Row Four"
            ContentList : SelectTo(oneRow, 5, 13)
        }
    ]
     m.top.content = ParseXMLContent(list)
         sleep(1000)
    m.top.mediaIndex=bundle.index
End Sub


Function GetContentFeed()
    mediaindex={}
    result = []
     xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://hosttec.online/rokuxml/achei/achei.json")
    rsp = xfer.GetToString()
    
'   jsonAsString = ReadAsciiFile("pkg:/components/Database.json")
'   mjson = ParseJSON(jsonAsString)

   json = ParseJson(rsp)
   print "json values>>>>", json
   for each category in json
            value = json.Lookup(category)
            if Type(value) = "roArray" 
                if category <> "series" 
                    for each itemData in value 
                    print "itemData>>", itemData.id
                         item = {}
                            if itemData.longDescription <> invalid
                                item.Description = itemData.longDescription
                            else
                                item.Description = itemData.shortDescription
                            end if
                            item.HDPosterUrl = itemData.thumbnail 
                            item.Title = itemData.title
                            item.releaseDate = itemData.releaseDate
                            item.guid = itemData.id
                            if itemData.content <> invalid
                                item.length = itemData.content.duration
                                item.url = itemData.content.videos[0].url
                                item.streamFormat = itemData.content.videos[0].videoType
                            end if
                    end for
                  
                end if
            end if
               result.Push(item)
               'mediaindex[item.guid]  = item
        end for
   
'    print "rsp output", mjson
'          responseArray = mjson["Videos"]
'          
'                        for each channel in responseArray
'                         item = {} 
'                            item.url = channel.Link
'                            item.streamFormat = "mp4"
'                            item.HDPosterUrl = channel.Thumbnail
'                            item.hdBackgroundImageUrl = channel.Thumbnail
'                            item.Title = channel.Title
'                            item.Description = channel.Title
'                            item.guid=channel.ContentId
'                         
'                          result.push(item)
'                          mediaindex[item.guid]  = item
'                        end for
    return {contentArray:result,index:mediaindex}
    
End Function


Function ParseXMLContent(list As Object)
    RowItems = createObject("RoSGNode","ContentNode")
    for each rowAA in list
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        for each itemAA in rowAA.ContentList
            item = createObject("RoSGNode","ContentNode")
            item.SetFields(itemAA)
            row.appendChild(item)
        end for
        RowItems.appendChild(row)
    end for
    return RowItems
End Function

Function SelectTo(array as Object, num = 25 as Integer, start = 0 as Integer) as Object
    result = []
    for i = start to array.count()-1
        result.push(array[i])
        if result.Count() >= num
            exit for
        end if
    end for
    return result
End Function