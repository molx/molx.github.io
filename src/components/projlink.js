import React from "react"
import projStyles from "./projlink.module.css"

export default props => (
    <div key={props.data.name} className={projStyles.main}>
        <a href={props.data.url}>
            <div>
                <div className={projStyles.img_wrapper}>
                    <img className={projStyles.icon} src={"/img/" + props.data.img + ".png"} alt="" />
                </div>
                <span className={projStyles.title}>{props.data.name}</span>
                <span className={projStyles.desc}>{props.data.desc}</span>
            </div>
        </a>
    </div>
)
