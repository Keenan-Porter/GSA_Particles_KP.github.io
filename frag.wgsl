struct VertexInput {
  @location(0) pos: vec2f,
  @builtin(instance_index) instance: u32,
};

struct VertexOutput {
  @builtin(position) pos: vec4f,
  @location(0) center:vec2f,
  @location(1) uv:vec2f
};

struct Particle {
  pos: vec2f,
  speed: f32
};

@group(0) @binding(0) var<uniform> frame: f32;
@group(0) @binding(1) var<uniform> res:   vec2f;
@group(0) @binding(2) var<storage> state: array<Particle>;

@vertex 
fn vs( input: VertexInput ) ->  VertexOutput {
  let size = input.pos * .25;
  let p = state[ input.instance ];
  let vout = vec4f((p.pos.x + size.x * p.speed), (p.pos.y + size.y * p.speed), 0.0, 1.);

  let out = VertexOutput(
    vout,
    p.pos,
    vout.xy
  );

  return out; 
}

@fragment 
fn fs( vtx: VertexOutput) -> @location(0) vec4f {

  let d = distance(vtx.uv.xy, vtx.center);
  var alpha = 1.0;
  if( d > .0015){
    alpha = smoothstep(.010 * ((vtx.uv.y - vtx.center.y)), d, .005 ); 
  }
  if (vtx.uv.x < vtx.center.x 
    && vtx.uv.y < vtx.center.y + .0015 
    && vtx.uv.y > vtx.center.y - .0015 ){
    alpha = smoothstep( .010 * ((vtx.uv.y - vtx.center.y)), d, .015 );
  }

  

  return vec4f(0.0, 1.0, .6, alpha);
}
