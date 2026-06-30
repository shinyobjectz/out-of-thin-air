import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import { Player } from "@remotion/player";
import { Photosynthesis, PhotosynthesisProps } from "./Photosynthesis";

const DEFAULT: PhotosynthesisProps = {
  title: "Preview",
  subtitle: "",
  accent: "#ffd166",
};

const loadProps = (): Promise<PhotosynthesisProps> =>
  fetch("../public/props.json?t=" + Date.now())
    .then((r) => (r.ok ? r.json() : DEFAULT))
    .catch(() => DEFAULT);

const App: React.FC = () => {
  const [props, setProps] = useState<PhotosynthesisProps>(DEFAULT);

  useEffect(() => {
    loadProps().then(setProps);
    const id = window.setInterval(() => {
      loadProps().then(setProps);
    }, 1200);
    return () => window.clearInterval(id);
  }, []);

  return (
    <div style={{ width: "100%", height: "100%", background: "#000" }}>
      <Player
        component={Photosynthesis}
        inputProps={props}
        durationInFrames={600}
        fps={30}
        compositionWidth={1920}
        compositionHeight={1080}
        style={{ width: "100%", height: "100%" }}
        controls={false}
        loop
        autoPlay
      />
    </div>
  );
};

const el = document.getElementById("root");
if (el) createRoot(el).render(<App />);
