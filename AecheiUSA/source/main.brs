sub Main(args)
  showChannelSGScreen(args)
end sub

sub showChannelSGScreen(args = invalid as Dynamic)
    print "in showChannelSGScreen"
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("HomeScene")
    
    m.global = screen.getGlobalNode()
    ? "args= "; formatjson(args)   
    deeplink = getDeepLinks(args)
    ? "deeplink= "; deeplink
    m.global.addField("deeplink", "assocarray", false)
    m.global.deeplink = deeplink
    
    screen.show()

    while(true)
        msg = wait(0, m.port)
    msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

Function getDeepLinks(args) as Object
print "args>> Main.brs>>", args
    deeplink = Invalid

    if args.contentId <> Invalid and args.mediaType <> Invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if

    return deeplink
end Function