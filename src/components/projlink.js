import React from "react"

export default props => (
    <div key={props.data.name} className={"project"}>
        <hr />
        <div>
            <img className={"project_icon"} src={"/img/" + props.data.img + ".png"} alt="" />
            <a href={props.data.url}>
                <span className={"octicon octicon-link"}>{props.data.name}</span>
            </a>
            : {props.data.desc}
        </div>
    </div>
)
