{{ (resources.Get "anims/vanta-rings/three.r92.min.js").Content | safeJS }}
{{ (resources.Get "anims/vanta-rings/vanta.rings.min.js").Content | safeJS }}

VANTA.RINGS({
    el: "#back"
});