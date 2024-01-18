int cycle(vec2 c, float limit){
    float infinity = 100.f;
    vec2 point = c;
    int l = int (limit);
    for (int i=0; i < l; i++){
        float a = point[0]*point[0] - point[1]*point[1];
        float b = 2.f*point[0]*point[1];
        point = vec2(a + c[0], b + c[1]);
        
        if ((point[0] > infinity) || (point[1] > infinity)) {
            return i;
        }
    }
    return 0;
}

vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);

    return a + b*cos( 6.28318*(c*t*10.f+d) );
}

float triangleWave(float x){
    float period = 15.f;
    float value = mod(x,period)/period;
    
    if (value < 0.5){
        return 2.f*value;
    }
    return 2.f*(1.f-value);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    highp vec2 doublePrecisionVector;
    
    vec2 focusPoint = vec2(0.3602134, -0.6413589712);
    //vec2 focusPoint = vec2((iMouse.x-500.f)/500.f, (iMouse.y-250.f)/500.f);
    
    
    float zoom = triangleWave(iTime/2.f);
    zoom = pow(2.f,22.f*zoom)/2.f;
    float limit = zoom/16.f+100.f;
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    uv = uv/zoom;
    vec2 fragPoint = vec2(uv[0]+focusPoint[0],uv[1]-focusPoint[1]);
    float colornum = float(cycle(fragPoint, limit))/(limit);
    if (colornum == 0.f){
        fragColor = vec4(0,0,0,1);
    } else {
        vec3 col = palette(colornum);
        fragColor = vec4(col,1);
    }
}