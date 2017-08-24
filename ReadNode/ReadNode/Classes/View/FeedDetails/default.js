(function() {
    if (window.ZKRArticleDefaultJS) {
        return
    }

    window.ZKRArticleDefaultJS = {
    }

    //图片加蒙层，夜间模式下
    window.addImageMask = function(img) {
        if (img.width == 0 && img.height == 0) {
            return;
        }

        var parentNode = img.parentNode;
        var botherNodes = parentNode.childNodes;
        for (var i = 0; i < botherNodes.length; i++) {
            if ('img_mask' == botherNodes[i].className) {
                return;
            }
        }

        if (parentNode.nodeName.toLowerCase() != 'div') {
            // 如果上层不是div，可能是未知格式的网页，会引发神奇的错误。
            // 例如上层是body时，添加蒙层会出现大面积黑色。
            // 所以这个时候索性不添加蒙层，避免未知格式引起的错误。
            return;
        }

        var mask = document.createElement('div');
        mask.className = 'img_mask';
        mask.style.opacity = 0.3;
        mask.style.backgroundColor = "#000";
        mask.style.position = "absolute";
        mask.style.left = "0px";
        mask.style.right = "0px";
        mask.style.top = "0px";
        mask.style.bottom = "0px";
        if (parentNode.onclick) {
            // 常规情况parentNode是imagebox，所以取parentNode的onclick
            mask.onclick = parentNode.onclick;
        } else {
            // 非常规情况，取img的onclick
            mask.onclick = img.onclick;
        }

        // 上层必须是relative，蒙层的absolute才能生效
        parentNode.style.position = "relative";
        parentNode.appendChild(mask);
    }

    window.initImageMask = function(id) {
        var imageId = 'id_image_' + id;
        var imageObj = document.getElementById(imageId);
        if (imageObj) {
            imageObj.onload = addImageMask(imageObj);
        }
    }

    window.addAllImagesMasks = function() {
        var imgs = document.getElementsByTagName("img");
        if (!imgs) {
            return;
        }
        for (var i = 0; i < imgs.length; i++) {
            addImageMask(imgs[i]);
        }
    }

    window.removeAllImagesMasks = function() {
        var imgs = document.getElementsByTagName("img");
        if (!imgs) {
            return;
        }

        var imgmask = Array.prototype.slice.call(document.querySelectorAll('.img_mask'));
        imgmask.forEach(function(e) {
            var parentNode = e.parentNode;
            parentNode.style.position = "";
            e.remove();
        });
    }

    window.changeImageSrc = function(id, src, resizeToHeight, isGIF, isNight) {
        var imageId = 'id_image_' + id;
        var imageObj = document.getElementById(imageId);
        var imgbox = document.getElementById('id_imagebox_' + id);
        if (imgbox) {
            var loadingImg = document.getElementById('id_loading_' + id);
            if (loadingImg) {//判断是否有loading图片，有则隐藏
                imgbox.removeChild(loadingImg);
            }
            var mask = document.getElementById('id_mask_' + id);
            if (mask) {//判断是否有loading图片，有则隐藏
                imgbox.removeChild(mask);
                if (isNight == false) {
                    imgbox.style.position = null;
                }
            }
        }

        if (imageObj) {
            var imgIsGIF = imageObj.getAttribute('is_gif');
            if (imgIsGIF == null) {
                imgIsGIF = false;
            }
            if (!imageObj.loaded || imgIsGIF != isGIF || isGIF) {
                $('#' + imageId).hide().bind("load", function() {
                    $(this).show();
                }).each(function() {
                    if (this.complete) $(this).trigger("load");
                });

                imageObj.src = src;

                var boxID = 'id_imagebox_' + id;
                var imageBox = document.getElementById(boxID);
                if (imageBox) {
                    imageBox.style.backgroundColor = 'transparent';
                }

                if (resizeToHeight != null) {
                    imageObj.style.height = resizeToHeight + 'px';
                }

                imageObj.loaded = true;
                imageObj.setAttribute('is_gif', isGIF);
            }
        }
    }

    window.gifLoading = function(src, index) {
        var imgbox = document.getElementById('id_imagebox_' + index);
        if (imgbox) {
            addGifImageLoadingMask(imgbox, index);

            var loadingImg = document.getElementById('id_loading_' + index);
            if (loadingImg) {
                imgbox.removeChild(loadingImg);
            }

            var loadingImg = document.createElement("img");
            loadingImg.setAttribute("id", "id_loading_" + index);
            loadingImg.src = src;
            loadingImg.style.width = "34px";
            loadingImg.style.height = "6px";
            var targetHeight = imgbox.offsetHeight;
            targetHeight += 70;
            loadingImg.style.marginTop =  "-" + targetHeight + "px";
            imgbox.appendChild(loadingImg);
        }
    }

    //图片加蒙层，夜间模式下
    window.addGifImageLoadingMask = function(imageBox, index) {
        var img = document.getElementById('id_image_' + index);
        if (!img || (img.width == 0 && img.height == 0)) {
            return;
        }

        var parentNode = imageBox;
        if (parentNode.nodeName.toLowerCase() != 'div') {
            // 如果上层不是div，可能是未知格式的网页，会引发神奇的错误。
            // 例如上层是body时，添加蒙层会出现大面积黑色。
            // 所以这个时候索性不添加蒙层，避免未知格式引起的错误。
            return;
        }

        var mask = document.getElementById('id_mask_' + index);
        if (mask) {//判断是否有loading图片，有则隐藏
            return;
        }

        var mask = document.createElement('div');
        mask.setAttribute("id", "id_mask_" + index);
        mask.style.opacity = 0.5;
        mask.style.backgroundColor = "#000";
        mask.style.position = "absolute";
        mask.style.left = "0px";
        mask.style.right = "0px";
        mask.style.top = "0px";
        mask.style.bottom = "0px";
        mask.style.height = img.height + "px"
            if (parentNode.onclick) {
            // 常规情况parentNode是imagebox，所以取parentNode的onclick
            mask.onclick = parentNode.onclick;
        } else {
            // 非常规情况，取img的onclick
            mask.onclick = img.onclick;
        }
        // 上层必须是relative，蒙层的absolute才能生效
        parentNode.style.position = "relative";
        parentNode.appendChild(mask);
    }

    //显示gif播放标识
    window.showGifFlag = function(scr, index) {
        var imgbox = document.getElementById('id_imagebox_' + index);
        if (!imgbox) {
            return;
        }
        var gifFlag = document.getElementById('id_gif_flag_' + index);//gif标识
        if (!gifFlag) {//判断是否有gif标识，没有则添加
            var gifFlag = document.createElement("img");
            gifFlag.setAttribute("id", "id_gif_flag_" + index);
            gifFlag.src = scr;
            gifFlag.style.width = "26px";
            gifFlag.style.height = "14px";
            gifFlag.style.marginTop =  "-62px"; // 14px(图片高度) + 7px(行距) + 10px(与图片的底边距) = 31px，乘以2=62px，不知道为什么要乘以2
            var left = imgbox.offsetWidth - 26;
            gifFlag.style.marginLeft =  left + "px";
            imgbox.appendChild(gifFlag);
        }
        gifFlag.style.display = "inline";
    }

    window.hideGifFlag = function(index) {
        var gifFlag = document.getElementById('id_gif_flag_' + index);//gif标识
        if (gifFlag) {
            gifFlag.style.display = "none";
        }
    }

    window.adjustPushImageHeight = function(id, width, height) {
        var imageId = 'id_image_' + id;
        var imageObj = document.getElementById(imageId);
        if (!imageObj) {
            return;
        }
        var adjustedImageHeight = parseInt(imageObj.parentNode.offsetWidth * height / width);
        imageObj.parentNode.style.height = adjustedImageHeight + "px";
    }

    window.loadScriptWithUrl = function(jsUrl) {
        var oHead = document.getElementsByTagName('HEAD').item(0);
        if (!oHead) {
            return;
        }
        var oScript = document.createElement("script");

        oScript.type = "text/javascript";

        oScript.src = jsUrl;

        oHead.appendChild(oScript);
    }

    window.loadScriptWithContent = function(jsContent) {
        var oHead = document.getElementsByTagName('HEAD').item(0);
        if (!oHead) {
            return;
        }
        var oScript = document.createElement("script");

        oScript.type = "text/javascript";

        oScript.text = jsContent;

        oHead.appendChild(oScript);
    }

    window.changeBGColor = function(titleColor, authorColor, lineColor, headerBgColor, inDarkMode) {
        if (titleColor) {
            document.body.style.color = titleColor;
            changeTextColor(titleColor, lineColor);
            colorLinks(titleColor);
            colorActiveLineColor(lineColor);
        }

        changeSpecialColor(titleColor, authorColor, lineColor, headerBgColor, inDarkMode);
    }

    window.changeSpecialColor = function(titleColor, authorColor, lineColor, headerBgColor, inDarkMode) {
    }

    window.colorLinks = function(hex) {
        var content = document.getElementById("content");
        if (!content) {
            content = document;
        }

        var links = content.getElementsByTagName("a");
        if (!links) {
            return;
        }
        for (var i = 0; i < links.length; i++) {
            if (links[i].href) {
                links[i].style.color = hex;
            }
        }
    }

    window.colorActiveLineColor = function(lineColor) {
        var service = document.getElementById("active_service");

        if (service != null) {
            service.style.borderBottom = "1px solid " + lineColor;

            var items = service.getElementsByClassName("active_item");
            for (var i = 0; i < items.length; i++) {
                items[i].style.borderTop = "1px solid " + lineColor;
            }
        }
    }

    window.changeTextSize = function(textSize) {
        if (textSize) {
            document.body.style.fontSize = textSize;
        }
    }

    window.changeImageBoxColor = function(backgroundColor, lineColor) {
        var imgs = document.getElementsByTagName("img");
        if (!imgs) {
            return;
        }
        for (var i = 0; i < imgs.length; i++) {
            var imageBox = document.getElementById('id_imagebox_' + i);
            var image = document.getElementById('id_image_' + i);
            if (!imageBox || !image) {
                continue;
            }
            // 因为没有填充过图片，所以可以更改它的背景色，填充过图片则保持透明色。具体原因请看本文件的changeImageSrc函数。
            if (!image.loaded) {
                imageBox.style.backgroundColor = backgroundColor;
            }
            // 对于第一张图，有可能是加了边框的，那么边框颜色也要改
            if (i == 0) {
                if (image.style.borderBottomColor != null) {
                    image.style.borderBottomColor = lineColor;
                }
            }
        }
    }

    window.changeTitleFontSize = function(fontSize, lineHeight) {
        var obj = document.getElementsByClassName("titleFont")[0];
        if (!obj) {
            return;
        }
        obj.style.fontSize = fontSize + "px";
        obj.style.lineHeight = lineHeight + "px";
    }

    window.getHeaderHeight = function() {
        var obj = document.getElementById("article_header");
        if (obj) {
            var height = obj.offsetHeight;
            return height;
        } else {
            return 0;
        }
    }

    window.addContent = function(content) {
        document.body.innerHTML += content;
        return 1;
    }

    window.changeObjTextColor = function(id, textColor) {
        var obj = document.getElementById(id);
        if (obj && textColor) {
            obj.style.color = textColor;
        }
    }

    window.changeObjBottomColor = function(id, lineColor) {
        var obj = document.getElementById(id);
        if (obj && lineColor) {
            obj.style.borderBottom = "1px solid " + lineColor;
        }
    }

    window.changeTextColor = function(textColor, lineColor) {
        changeObjBottomColor('headerLine', lineColor);
        changeObjTextColor('article_title', textColor);
    }

    window.switchNight = function(night) {
        if (night == true) {
            document.body.className = "night";
        } else {
            document.body.className = null;
        }
    }

    window.enableLog = function() {
        window.log = function(msg) {
            var logIframe = document.createElement('iframe');
            logIframe.style.display = 'none';
            logIframe.src = 'zkrwvlog://' + msg;
            document.documentElement.appendChild(logIframe);
            logIframe.parentNode.removeChild(logIframe);
        }
    }

    if (window.onerror) {
        window.orgonerror = window.onerror;
    }

    window.onerror = function(msg, url, line, col, error) {
        // Note that col & error are new to the HTML 5 spec and may not be
        // supported in every browser.  It worked for me in Chrome.
        var extra = !col ? '' : '\ncolumn: ' + col;
        extra += !error ? '' : '\nerror: ' + error;

        // You can view the information in an alert to see things working like this:
        log("Error: " + msg + "\nline: " + line + extra);

        if (window.orgonerror) {
            window.orgonerror(msg, url, line, col, error);
        }

        // TODO: Report this error via ajax so you can keep track
        //       of what pages have JS issues

        var suppressErrorAlert = false;
        // If you return true, then error alerts (like in older versions of
        // Internet Explorer) will be suppressed.
        return suppressErrorAlert;
    }

    var readyframe = document.createElement('iframe');
    readyframe.style.display = 'none';
    readyframe.src = 'zkrarticlejsready://host';
    document.documentElement.appendChild(readyframe);
    readyframe.parentNode.removeChild(readyframe);
})();
