import React from "react"
import * as projStyles from "./projlink.module.css"

const Props = ({ data }) => (
    <div key={data.name} className={projStyles.main}>
        <a href={data.url}>
            <div>
                <div className={projStyles.img_wrapper}>
                    <img className={projStyles.icon} src={"/img/" + data.img + ".png"} alt="" />
                </div>
                <span className={projStyles.title}>{data.name}</span>
                <span className={projStyles.desc}>{data.desc}</span>
            </div>
        </a>
    </div>
)
export default Props;