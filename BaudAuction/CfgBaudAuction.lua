U1RegisterAddon("BaudAuction", {
    title = "拍卖界面增强",
    tags = { TAG_TRADING, },
    desc = "拍卖界面增强",
    load = "NORMAL",
    defaultEnable = 1,
    icon = [[Interface\Icons\INV_Misc_Coin_02]],
    nopic = 1,
    -- conflicts = { "AuctionLite", },

    toggle = function(name, info, enable, justload)
    end,

    -- {
    --     text = "配置选项",
    --     callback = function(cfg, v, loading)
    --         local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
    --         func("Auctionator")
    --     end
    -- }
});
