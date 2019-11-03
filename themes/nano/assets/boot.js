// Minified version of isMobile included in the HTML since it's small
// Source: https://github.com/kaimallea/isMobile
(function () {var f=/iPhone/i,j=/iPod/i,p=/iPad/i,g=/\bAndroid(?:.+)Mobile\b/i,i=/Android/i,d=/\bAndroid(?:.+)SD4930UR\b/i,e=/\bAndroid(?:.+)(?:KF[A-Z]{2,4})\b/i,c=/Windows Phone/i,h=/\bWindows(?:.+)ARM\b/i,k=/BlackBerry/i,l=/BB10/i,m=/Opera Mini/i,n=/\b(CriOS|Chrome)(?:.+)Mobile/i,o=/Mobile(?:.+)Firefox\b/i;function b($,a){return $.test(a)}function a($){var a=($=$||("undefined"!=typeof navigator?navigator.userAgent:"")).split("[FBAN");void 0!==a[1]&&($=a[0]),void 0!==(a=$.split("Twitter"))[1]&&($=a[0]);var r={apple:{phone:b(f,$)&&!b(c,$),ipod:b(j,$),tablet:!b(f,$)&&b(p,$)&&!b(c,$),device:(b(f,$)||b(j,$)||b(p,$))&&!b(c,$)},amazon:{phone:b(d,$),tablet:!b(d,$)&&b(e,$),device:b(d,$)||b(e,$)},android:{phone:!b(c,$)&&b(d,$)||!b(c,$)&&b(g,$),tablet:!b(c,$)&&!b(d,$)&&!b(g,$)&&(b(e,$)||b(i,$)),device:!b(c,$)&&(b(d,$)||b(e,$)||b(g,$)||b(i,$))||b(/\bokhttp\b/i,$)},windows:{phone:b(c,$),tablet:b(h,$),device:b(c,$)||b(h,$)},other:{blackberry:b(k,$),blackberry10:b(l,$),opera:b(m,$),firefox:b(o,$),chrome:b(n,$),device:b(k,$)||b(l,$)||b(m,$)||b(o,$)||b(n,$)},any:!1,phone:!1,tablet:!1};return r.any=r.apple.device||r.android.device||r.windows.device||r.other.device,r.phone=r.apple.phone||r.android.phone||r.windows.phone,r.tablet=r.apple.tablet||r.android.tablet||r.windows.tablet,r}window.isMobile=a();})();

function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
            tmp = item.split("=");
            if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
}

function autorun()
{
    if (isMobile.phone || isMobile.tablet) {
        // No animation/fonts on mobile and tablet
    }
    else {
        // -- Download the animation --
        const script = document.createElement('script');
        script.onload = function () {
            // do stuff with the script
        };

        let anim = window.anim;
        if (!window.anim && window.anims) {
            const wantedAnim = findGetParameter('anim');
            let animIdx = Math.floor(Math.random() * Math.floor(window.anims.length));

            if (wantedAnim) {
                const wantedIndex = window.anims.findIndex(anim => anim.slug === wantedAnim);
                if (wantedIndex >= 0) animIdx = wantedIndex;
            }

            anim = window.anims[animIdx].slug;

            document.getElementById('currentAnim').innerHTML = 'Current animation is <a href="/anims/' + anim +'">'
                + window.anims[animIdx].title + '</a>.';
        }
        script.src = "/anims/" + anim + "/index.min.js";
        document.head.appendChild(script);

        // -- Download web-fonts --
        const head  = document.getElementsByTagName('head')[0];
        const link  = document.createElement('link');
        link.rel  = 'stylesheet';
        link.type = 'text/css';
        link.href = 'https://fonts.googleapis.com/css?family=Montserrat|Oxygen&display=swap';
        link.media = 'all';
        head.appendChild(link);
    }
}
if (document.addEventListener) document.addEventListener("DOMContentLoaded", autorun, false);
else if (document.attachEvent) document.attachEvent("onreadystatechange", autorun);
else window.onload = autorun;