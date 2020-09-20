{{ (resources.Get "anims/common/twgl.min.js").Content | safeJS }}

(function(){
    function w() {
        return Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    }
    function h() {
        return Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    }

    // Create the shader in DOM (required by TWGL) --
    function createShader(id, content) {
        const shader = document.createElement('script');
        shader.id = id;
        shader.setAttribute('type', 'notjs');
        shader.textContent = content;
        document.body.appendChild(shader);
    }

    createShader('vs', '{{ (resources.Get "anims/hexa-1/vertexShader.glsl").Content | replaceRE "\n" "\\n" }}');
    createShader('fs', '{{ (resources.Get "anims/hexa-1/fragmentShader.glsl").Content | replaceRE "\n" "\\n" }}');

    // Create the canvas --
    const background = document.getElementById('back');
    const canvas = document.createElement('canvas');
    background.appendChild(canvas);

    // Get it to full size
    function updateSize() {
        canvas.width = w();
        canvas.height = h();
    }
    window.addEventListener('resize', updateSize, false);
    updateSize();

    // Get the scroll value --
    let scroll = window.scrollY / h();
    window.onscroll = function onScroll() {
        scroll = window.scrollY / h();
    };

    // Init Webgl --
    const gl = canvas.getContext('webgl');
    const programInfo = twgl.createProgramInfo(gl, ['vs', 'fs']);

    const arrays = {
        position: [-1, -1, 0, 1, -1, 0, -1, 1, 0, -1, 1, 0, 1, -1, 0, 1, 1, 0],
    };
    const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);

    function render(time) {
        twgl.resizeCanvasToDisplaySize(gl.canvas);
        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

        const uniforms = {
            iTime: time * 0.001,
            iResolution: [gl.canvas.width, gl.canvas.height],
            iScroll: scroll,
            leftMargin: 500
        };

        gl.useProgram(programInfo.program);
        twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
        twgl.setUniforms(programInfo, uniforms);
        twgl.drawBufferInfo(gl, bufferInfo);

        requestAnimationFrame(render);
    }
    requestAnimationFrame(render);
}());
